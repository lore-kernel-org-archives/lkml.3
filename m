Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3COQl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:41:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab3COQl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:41:28 -0400
Date: Fri, 15 Mar 2013 17:39:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH 1/1] poweroff: change orderly_poweroff() to use
	schedule_work()
Message-ID: <20130315163916.GA31995@redhat.com>
References: <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com> <CAKi4VALkUhOtP_8BOi3Mi8fTz8TUPwmwQq7WW27BEDue2wFNRw@mail.gmail.com> <20130312182210.GA15862@redhat.com> <CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com> <20130312191118.GA17439@redhat.com> <CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com> <20130312203514.GA23488@redhat.com> <20130313174641.GA28083@redhat.com> <20130313174705.GB28083@redhat.com> <20130314152819.7fb1242b493e8bad2d34671b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314152819.7fb1242b493e8bad2d34671b@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14, Andrew Morton wrote:
>
> On Wed, 13 Mar 2013 18:47:05 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > This means that orderly_poweroff() becomes async even if we do not
> > run the command and always succeeds, schedule_work() can only fail
> > if the work is already pending. We can export __orderly_poweroff()
> > and change the non-atomic callers which want the old semantics.
> >
> > ...
> >
> > @@ -2218,21 +2237,9 @@ static int __orderly_poweroff(void)
> >   */
> >  int orderly_poweroff(bool force)
> >  {
> > +	if (force) /* do not override the pending "true" */
> > +		poweroff_force = true;
> > +	schedule_work(&poweroff_work);
> > +	return 0;
> >  }
>
> afaict the current version of orderly_poweroff() will never return -
> either __orderly_poweroff() will block until the machine shuts down or
> kernel_power_off() will do so.

Note that __orderly_poweroff() uses UMH_WAIT_EXEC, not UMH_WAIT_PROC,
so it returns right after /sbin/poweroff starts to execute.

So it is already asynchronous unless execve() fails.

> However with this patch there is a path via which orderly_poweroff()
> can return to its caller, I think?

See above, but please also read the changelog.

With this patch orderly_poweroff() is always async, even if exec fails,
but

> If so, the caller might be rather
> surprised and we're exercising never-before-used code paths.  In fact
> if the surprised caller goes oops, the poweroff might not occur at all.

This should not happen.

Anyway. Please also note that now we can export __orderly_poweroff() and
probably change it, it can have another argument "bool use_UMH_WAIT_PROC".

	int __orderly_poweroff(bool force, bool sync)
	{
		int wait = sync ? UMH_WAIT_EXEC : UMH_WAIT_EXEC;

		ret = call_usermodehelper(argv[0], argv, envp, wait);

		if (force) {
			// EXEC failed or /sbin/poweroff didn't do its work
			if (ret || sync)
				kernel_power_off();
		}
	}

The non-atomic callers can use __orderly_poweroff(sync => true).

---------------------------------------------------------------------------
And, Andrew, et all... Could you help with another mentioned problem? It is
really trivial, but exactly because it is trivial I do not know what should
I do.

To remind, say, argv_split(poweroff_cmd) can race with sysctl changing this
string, in this case it can write to the memory after argv[] array. We can
fix this, or we can rewrite argv_split/free:

	void argv_free(char **argv)
	{
		kfree(argv[-1]);
		kfree(argv);
	}

	char **argv_split(gfp_t gfp, const char *str, int *argcp)
	{
		char *argv_str;
		bool was_space;
		char **argv, **argv_ret;
		int argc;

		argv_str = kstrndup(str, KMALLOC_MAX_SIZE, gfp);
		if (!argv_str)
			return NULL;

		argc = count_argc(argv_str);
		argv = kmalloc(sizeof(*argv) * (argc + 2), gfp);
		if (!argv) {
			kfree(argv_str);
			return NULL;
		}

		*argv = argv_str;
		argv_ret = ++argv;
		for (was_space = true; *argv_str; argv_str++) {
			if (isspace(*argv_str)) {
				was_space = true;
				*argv_str = 0;
			} else if (was_space) {
				was_space = false;
				*argv++ = argv_str;
			}
		}
		*argv = NULL;

		if (argcp)
			*argcp = argc;
		return argv_ret;
	}

This way it uses a single kstrndup() to keep the arguments and it is
always safe.

But, whatever we do with argv_split(), it can hit the string "in between".
Personally I think we do not really care, but...

Perhaps we should add proc_dostring_lock() which takes some lock and
modify the callers of argv_split() (or add argv_split_lock) ?

Or perhaps we should introduce the rwsem which should protect every
sysctl-string and proc_dostring() should take this lock?

Help! I'd prefer to rewrite argv_split(), but I agree with any suggestion
in advance.

Oleg.


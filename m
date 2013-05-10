Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab3EJROJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 13:14:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab3EJROI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 13:14:08 -0400
Date: Fri, 10 May 2013 19:10:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] init/Kconfig: Add option to set modprobe command
Message-ID: <20130510171054.GA27479@redhat.com>
References: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com> <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com> <20130510125826.GA553@redhat.com> <CAKi4VALE8tFUTZ1qYwm0Eth1zFMU8xA6XC5RTnF1KCKYQp-0NQ@mail.gmail.com> <20130510153638.GA8179@redhat.com> <CAKi4VAJPXgiik9CGrVyk7cCvz-1913p1KL8tn5FvxH4w0r27bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKi4VAJPXgiik9CGrVyk7cCvz-1913p1KL8tn5FvxH4w0r27bg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10, Lucas De Marchi wrote:
>
> On Fri, May 10, 2013 at 12:36 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Well, personally I think it would be better to use kasprintf(), see the
> > patch I sent (it is actually wrong, needs kfree(args) before return).
> >
> > Or. How about the patch below? It should be split into 2 changes:
> >
> >         1. Introduce __argv_split(). It can have more callers, for
> >            example do_coredump() and ftrace_function_filter_re()
> >            can use it to avoid kstrndup() + kfree().
> >
> >         2. Change call_modprobe() to use kasprintf() + __argv_split().
>
> Seems better. In your previous version I was troubled about
> duplicating the string twice.

Oh, compared to other things we need to do this is nothing ;)

But to me it just looks better this way.

> Now it's weird freeing a
> user-allocated-string,

This is fine, the "weird" thing is that it frees the string even if
fails. But this simplifies the usage.

> but I think it's a good tradeoff and covers other use cases as you
> pointed out as well.

OK, good.

> Ok. I'll give it a try.

Please wait a bit, I'll send v2. See below.

> > -char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
> > +char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe -q --";

No. This is incompatible change, we shouldn't do this.

> > +       args = kasprintf(GFP_KERNEL, "%s %s", modprobe_path, module_name);

This should be kasprintf("%s -q -- %s").

And it needs a comment to explain that we are safe even if we race
with proc_dostring().

Oleg.


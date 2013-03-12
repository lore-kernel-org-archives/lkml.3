Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933538Ab3CLUh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:37:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514Ab3CLUh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:37:26 -0400
Date: Tue, 12 Mar 2013 21:35:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: Regression with orderly_poweroff()
Message-ID: <20130312203514.GA23488@redhat.com>
References: <1363058712.4534.12.camel@pasglop> <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com> <CAKi4VALkUhOtP_8BOi3Mi8fTz8TUPwmwQq7WW27BEDue2wFNRw@mail.gmail.com> <20130312182210.GA15862@redhat.com> <CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com> <20130312191118.GA17439@redhat.com> <CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12, Linus Torvalds wrote:
>
> So yeah, I guess
> everything could just go into a workqueue.

OK, I'll try to make the patch tomorrow. Should be trivial but it is
not clear how we should pass "bool force" without allocating the
work_struct which would be nice to avoid.

And I am a bit worried about UMH_WAIT_EXEC from system_wq. Should be
fine afaics...

And. It seems there is another problem. argv_split(poweroff_cmd) can
obviously race with proc_dostring() ? If nothing else, argv_split()
doesn't check 'argc' when it does "*argvp++ = t". And this is not
__orderly_poweroff-specific. This looks simple... and probably we can
even simplify argv_split/argv_free. We can simply kstrndup() the
original string once and do s/space/0/.

Oleg.


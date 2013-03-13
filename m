Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934100Ab3CMRsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:48:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905Ab3CMRsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:48:53 -0400
Date: Wed, 13 Mar 2013 18:46:41 +0100
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
Subject: [PATCH 0/1] poweroff: change orderly_poweroff() to use
	schedule_work()
Message-ID: <20130313174641.GA28083@redhat.com>
References: <1363058712.4534.12.camel@pasglop> <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com> <CAKi4VALkUhOtP_8BOi3Mi8fTz8TUPwmwQq7WW27BEDue2wFNRw@mail.gmail.com> <20130312182210.GA15862@redhat.com> <CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com> <20130312191118.GA17439@redhat.com> <CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com> <20130312203514.GA23488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312203514.GA23488@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12, Oleg Nesterov wrote:
>
> On 03/12, Linus Torvalds wrote:
> >
> > So yeah, I guess
> > everything could just go into a workqueue.
>
> OK, I'll try to make the patch tomorrow. Should be trivial but it is
> not clear how we should pass "bool force" without allocating the
> work_struct which would be nice to avoid.

Yes, it would be nice to keep it simple and use a single work/arg.

Could you review? The change is trivial but

	- orderly_poweroff() always return 0.

	- the patch assumes that orderly_poweroff(false) after
	  orderly_poweroff(true) acts as "force = true". Only xen
	  uses "false", I hope this is fine.

	  In fact I think we can change poweroff_force argument
	  unconditionally, this "if (force)" check is mostly
	  documentation.

	  But we can add the locking or even allocate work_struct
	  every time if this is wrong (or just looks wrong).

	- The patch assumes that orderly_poweroff() doesn't need
	  the keventd_up() check, I hope this is correct...


Lucas, Andrew, sorry. If this patch will be applied, then

	kernel-sysc-use-the-simpler-call_usermodehelper.patch

should be dropped. Or I can redo this fix on top of -mm cleanup.

> And. It seems there is another problem. argv_split(poweroff_cmd) can
> obviously race with proc_dostring() ?

I'll send another patch...

Oleg.


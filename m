Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbaDBX54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:57:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933423AbaDBX5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:57:55 -0400
Date: Thu, 3 Apr 2014 01:57:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
In-Reply-To: <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1404030155240.32122@pobox.suse.cz>
References: <20140402144219.4cafbe37@gandalf.local.home> <20140402221212.GD16570@mguzik.redhat.com> <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com> <alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz> <20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
 <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com> <alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz> <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2014, Linus Torvalds wrote:

> > Which doesn't really protect you from tasks that do open()/write()/close()
> > cycle for /dev/kmsg write every 2ms though.
> 
> I don't think we should try to protect against wilful bad behavior
> unless that is shown to be necessary. Yeah, if it turns out that
> systemd really does that just to mess with us, we'd need to extend it,
> but in the absence of proof to the contrary, maybe this simple
> attached patch works?
> 
> TOTALLY UNTESTED. But it really isn't complex.

[ ... snip ... [
@@ -483,6 +484,8 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 
 	if (!user)
 		return -EBADF;
+	if (!___ratelimit(&user->rs, current->comm))
+		return 0;

I am admittedly rather new to this 'abuse the hell out of kernel 
ringbuffer' thing, but shouldn't we better be limiting the 
devkmsg_writev()?

-- 
Jiri Kosina
SUSE Labs

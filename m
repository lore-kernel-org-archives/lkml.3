Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaBNQQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:16:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50911 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaBNQQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:16:33 -0500
Date: Fri, 14 Feb 2014 16:16:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140214161623.GU18016@ZenIV.linux.org.uk>
References: <CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
 <20140212040358.GA25327@redhat.com>
 <20140212042215.GN18016@ZenIV.linux.org.uk>
 <20140212054043.GB13997@dastard>
 <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
 <20140212113928.GO18016@ZenIV.linux.org.uk>
 <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
 <20140212211421.GP18016@ZenIV.linux.org.uk>
 <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
 <20140214161302.GA16416@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214161302.GA16416@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 08:13:02AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 12, 2014 at 01:32:55PM -0800, Linus Torvalds wrote:
> > We'd have to teach each user of "dequeue_signal()" to free the siginfo
> > thing. Which shouldn't be too bad - I think we've collected all of
> > that into generic code, and there isn't the mass or architecture code
> > that knows about these things any more. But there are a few odd
> > drivers etc and signalfd.
> 
> The few odd drivers are nbd, jffs2 and the usb mass storage gadget.
> All of these have in common that they try to handle signals in a kernel
> thread (which we don't even allow by default), and that they ignore the
> siginfo.  I think they could mostly be replaced by an addition to the
> kthread API to allow a kthread to be killed by signals for legacy
> reasons.

FWIW, there's a funny situation - all users of dequeue_signal_lock()
actually ignore info completely.  I'm not saying that we ought to
stop returning it, but e.g. jbd part of that patch is simply
diff --git a/fs/jffs2/background.c b/fs/jffs2/background.c
index 2b60ce1..aefdff2 100644
--- a/fs/jffs2/background.c
+++ b/fs/jffs2/background.c
@@ -119,13 +119,14 @@ static int jffs2_garbage_collect_thread(void *_c)
                /* Put_super will send a SIGKILL and then wait on the sem.
                 */
                while (signal_pending(current) || freezing(current)) {
-                       siginfo_t info;
+                       ksiginfo_t info;
                        unsigned long signr;
 
                        if (try_to_freeze())
                                goto again;
 
                        signr = dequeue_signal_lock(current, &current->blocked, &info);
+                       dismiss_siginfo(&info);
 
                        switch(signr) {
                        case SIGSTOP:

Not complicated at all.  Where it does get complicated is ->last_siginfo and
PTRACE_SETSIGINFO - getting that reasonably clean is what I'm still fighting
right now...

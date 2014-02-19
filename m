Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaBSNA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:00:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbaBSNAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:00:54 -0500
Date: Wed, 19 Feb 2014 14:03:09 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-rt-users@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>
Subject: Re: locking changes in tty broke low latency feature
Message-ID: <20140219130308.GC1851@redhat.com>
References: <20140218093829.GC1741@redhat.com>
 <5303DABD.9000302@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5303DABD.9000302@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 18, 2014 at 05:12:13PM -0500, Peter Hurley wrote:
> On 02/18/2014 04:38 AM, Stanislaw Gruszka wrote:
> >Hi,
> >
> >setserial has low_latency option which should minimize receive latency
> >(scheduler delay). AFAICT it is used if someone talk to external device
> >via RS-485/RS-232 and need to have quick requests and responses . On
> >kernel this feature was implemented by direct tty processing from
> >interrupt context:
> >
> >void tty_flip_buffer_push(struct tty_port *port)
> >{
> >         struct tty_bufhead *buf = &port->buf;
> >
> >         buf->tail->commit = buf->tail->used;
> >
> >         if (port->low_latency)
> >                 flush_to_ldisc(&buf->work);
> >         else
> >                 schedule_work(&buf->work);
> >}
> >
> >But after 3.12 tty locking changes, calling flush_to_ldisc() from
> >interrupt context is a bug (we got scheduling while atomic bug report
> >here: https://bugzilla.redhat.com/show_bug.cgi?id=1065087 )
> >
> >I'm not sure how this should be solved. After Peter get rid all of those
> >race condition in tty layer, we probably don't want go back to use
> >spin_lock's there. Maybe we can create WQ_HIGHPRI workqueue and schedule
> >flush_to_ldisc() work there. Or perhaps users that need to low latency,
> >should switch to thread irq and prioritize serial irq to meat
> >retirements. Anyway setserial low_latency is now broken and all who use
> >this feature in the past can not do this any longer on 3.12+ kernels.
> >
> >Thoughts ?
> 
> Can you give me an idea of your device's average and minimum required
> latency (please be specific)?  Is your target arch x86 [so I can evaluate the
> the impact of bus-locked instructions relative to your expected]?
> 
> Also, how painful would it be if unsupported termios changes were rejected
> if the port was in low_latency mode and/or if low_latency setting was
> disallowed because of termios state?
> 
> It would be pointless to throttle low_latency, yes?
> 
> What would be an acceptable outcome of being unable to accept input?
> Corrupted overrun? Dropped i/o? Queued for later? Please explain with
> comparison to the outcome of missed minimum latency.

I'm sorry, I can not answer your questions.

For what I googled it looks like users wanted to get rid of 10ms jitter
caused by scheduler. Unfortunately that is all I know. I'm not user of
this feature and I don't know what are exact expectations. I'm adding Hal,
who reported bug to RH bugzilla, perhaps he can tell more about what
expectations are.

For now, since issue is not easy fixable, perhaps we should just fix
scheduling while atomic bug and add warning like on below patch ?

Thanks
Stanislaw

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 765125d..0fe6d65 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -504,9 +504,13 @@ void tty_flip_buffer_push(struct tty_port *port)
 
 	buf->tail->commit = buf->tail->used;
 
-	if (port->low_latency)
-		flush_to_ldisc(&buf->work);
-	else
+	if (port->low_latency) {
+		if (WARN_ONCE(in_irq() || irqs_disabled(),
+			      "serial low_latency feature can not be used in interrupt context"))
+			schedule_work(&buf->work);
+		else
+			flush_to_ldisc(&buf->work);
+	} else
 		schedule_work(&buf->work);
 }
 EXPORT_SYMBOL(tty_flip_buffer_push);

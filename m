Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaBRJgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:36:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbaBRJgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:36:08 -0500
Date: Tue, 18 Feb 2014 10:38:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: locking changes in tty broke low latency feature
Message-ID: <20140218093829.GC1741@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

setserial has low_latency option which should minimize receive latency
(scheduler delay). AFAICT it is used if someone talk to external device
via RS-485/RS-232 and need to have quick requests and responses . On
kernel this feature was implemented by direct tty processing from
interrupt context:

void tty_flip_buffer_push(struct tty_port *port)
{
        struct tty_bufhead *buf = &port->buf;

        buf->tail->commit = buf->tail->used;

        if (port->low_latency)
                flush_to_ldisc(&buf->work);
        else
                schedule_work(&buf->work);
} 

But after 3.12 tty locking changes, calling flush_to_ldisc() from
interrupt context is a bug (we got scheduling while atomic bug report
here: https://bugzilla.redhat.com/show_bug.cgi?id=1065087 )

I'm not sure how this should be solved. After Peter get rid all of those
race condition in tty layer, we probably don't want go back to use
spin_lock's there. Maybe we can create WQ_HIGHPRI workqueue and schedule
flush_to_ldisc() work there. Or perhaps users that need to low latency,
should switch to thread irq and prioritize serial irq to meat
retirements. Anyway setserial low_latency is now broken and all who use
this feature in the past can not do this any longer on 3.12+ kernels.
 
Thoughts ?

Stanislaw


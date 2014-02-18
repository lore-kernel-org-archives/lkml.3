Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaBRWMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:12:19 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34748 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751587AbaBRWMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:12:17 -0500
Message-ID: <5303DABD.9000302@hurleysoftware.com>
Date: Tue, 18 Feb 2014 17:12:13 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-rt-users@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: locking changes in tty broke low latency feature
References: <20140218093829.GC1741@redhat.com>
In-Reply-To: <20140218093829.GC1741@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislaw,

On 02/18/2014 04:38 AM, Stanislaw Gruszka wrote:
> Hi,
>
> setserial has low_latency option which should minimize receive latency
> (scheduler delay). AFAICT it is used if someone talk to external device
> via RS-485/RS-232 and need to have quick requests and responses . On
> kernel this feature was implemented by direct tty processing from
> interrupt context:
>
> void tty_flip_buffer_push(struct tty_port *port)
> {
>          struct tty_bufhead *buf = &port->buf;
>
>          buf->tail->commit = buf->tail->used;
>
>          if (port->low_latency)
>                  flush_to_ldisc(&buf->work);
>          else
>                  schedule_work(&buf->work);
> }
>
> But after 3.12 tty locking changes, calling flush_to_ldisc() from
> interrupt context is a bug (we got scheduling while atomic bug report
> here: https://bugzilla.redhat.com/show_bug.cgi?id=1065087 )
>
> I'm not sure how this should be solved. After Peter get rid all of those
> race condition in tty layer, we probably don't want go back to use
> spin_lock's there. Maybe we can create WQ_HIGHPRI workqueue and schedule
> flush_to_ldisc() work there. Or perhaps users that need to low latency,
> should switch to thread irq and prioritize serial irq to meat
> retirements. Anyway setserial low_latency is now broken and all who use
> this feature in the past can not do this any longer on 3.12+ kernels.
>
> Thoughts ?

Can you give me an idea of your device's average and minimum required
latency (please be specific)?  Is your target arch x86 [so I can evaluate the
the impact of bus-locked instructions relative to your expected]?

Also, how painful would it be if unsupported termios changes were rejected
if the port was in low_latency mode and/or if low_latency setting was
disallowed because of termios state?

It would be pointless to throttle low_latency, yes?

What would be an acceptable outcome of being unable to accept input?
Corrupted overrun? Dropped i/o? Queued for later? Please explain with
comparison to the outcome of missed minimum latency.

Regards,
Peter Hurley

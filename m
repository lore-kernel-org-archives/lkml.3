Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab3LNVAO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 16:00:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51995 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3LNVAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 16:00:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH v2 16/16] misc: support for I-8024 in LP-8x4x
Date: Sat, 14 Dec 2013 21:59:39 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Landley <rob@landley.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com> <1386901645-28895-1-git-send-email-ynvich@gmail.com> <1386901645-28895-17-git-send-email-ynvich@gmail.com>
In-Reply-To: <1386901645-28895-17-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312142159.40250.arnd@arndb.de>
X-Provags-ID: V02:K0:F8ufDW9WOdwBA2QWFK3vFP2+LXqiSrEDZYk/fU41Tau
 EwEkPtIjadfYyj8QZ8SDkzH+yFbJ5SGzJ3IJ4U22FX0B7gUX2Y
 w31nU4F2a0ZYJ8ytzsTTbjOxy+J0zUMF5B4+7Rn2HC1J+N35aJ
 vP1cWN8q7QbVi8BP9V03XWl+Qf0hA6ObaNVVmxf27s/JgT/MkU
 TAYzFsj/sQLteYxWwcVyTOZqGYmKZ+UTTWJbWi8lwmjIu4LG9s
 OlGnsWg+yf+L1ijtxLMeQ/6OgCVl0QGUEnFMVXshHrAPIEj5Im
 a8jmsW81jxDt7udpd5uh0o7iwfG50sad75hKOlw+tVma/ofQ7Y
 DNfruw5+eZ0s8VV6Ks2M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 December 2013, Sergei Ianovich wrote:
> +void nsleep(unsigned long nanosec)
> +{
> +       ktime_t t = ns_to_ktime(nanosec);
> +       long state = current->state;
> +
> +       __set_current_state(TASK_UNINTERRUPTIBLE);
> +       schedule_hrtimeout(&t, HRTIMER_MODE_REL);
> +       __set_current_state(state);
> +}
> +
> +static void lp8x4x_slot_reset_AO(struct lp8x4x_slot *s)
> +{
> +       int i;
> +       mutex_lock(&s->lock);
> +       for (i = 0; i < s->AO_len; i++)
> +               s->AO[i] = 0x2000;
> +       iowrite8(0x00, s->data_addr);
> +       nsleep(450);
> +       iowrite8(0xff, s->data_addr);
> +       mutex_unlock(&s->lock);
> +}

Have you checked that the nsleep definition actually does the
right thing here? 450 nanoseconds must be close the latency
you get from calling schedule_hrtimeout(). I'd suggest using
either ndelay() or usleep_range() instead, depending on your
needs.

If nsleep is really useful here, we should probably add that
as a generic API rather than having it in one driver.

	Arnd

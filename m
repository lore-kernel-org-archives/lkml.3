Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030827AbaLLQhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:37:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56954 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030210AbaLLQh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:37:29 -0500
Date: Fri, 12 Dec 2014 16:36:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "moderated list:ARM/CLKDEV SUPPORT" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        boris.brezillon@free-electrons.com
Message-ID: <20141212163653.GO11764@sirena.org.uk>
References: <1418226513-14105-2-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H8fFO+isr9ADh2Iv"
Content-Disposition: inline
In-Reply-To: <1418226513-14105-2-git-send-email-a.hajda@samsung.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 01/15] drivers/base: add track framework
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H8fFO+isr9ADh2Iv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2014 at 04:48:19PM +0100, Andrzej Hajda wrote:
> track is a generic framework for safe tracking presence of any kernel objects
> having an id. There are no special requirements about type of object or its
> id. Id shall be unique.

This is pretty confusing, when it talks about "kernel objects" that
sounds like it means struct kobject but in fact there's no connection
with that or any of the other kernel object stuff.  Perhaps it makes
sense but it should be addressed.

> Typical usage of the framework by consumer looks as follow:
> 1. Consumer registers notifier callback for objects with given id.

This is also a custom thing not connected with the notifier mechanism
implemented by struct notifier_block.  Again this should probably be
addressed, even if it's just used internally it seems like there should
be some opportunity for code reuse here.

> +	case track_task_up:
> +		node = track_get_node(track, task->type, task->id, true);
> +
> +		node->up = true;
> +		node->data = task->data;
> +		list_for_each_entry_safe(itb, node->itb_next, &node->itb_head,
> +					 list)
> +			itb->callback(itb, node->data, true);
> +		return;
> +	case track_task_down:

I'm not sure the up and down naming is the most obvious naming for
users.  It's obviously inspired by semaphores but it's not entirely
obvious that this is going to make things clear and meaningful for
someone trying to understand the interface.

> +static int track_process_queue(struct tracker *track)
> +{
> +	struct track_task *task, *ptask = NULL;
> +	unsigned long flags;
> +	bool empty;
> +
> +	/* Queue non-emptiness is used as a sentinel to prevent processing
> +	 * by multiple threads, so we cannot delete entry from the queue
> +	 * until it is processed.
> +	 */
> +	while (true) {
> +		spin_lock_irqsave(&track->queue_lock, flags);
> +
> +		if (ptask)
> +			list_del(&ptask->list);
> +		task = list_first_entry(&track->queue,
> +					struct track_task, list);
> +
> +		empty = list_empty(&track->queue);
> +		if (empty)
> +			complete_all(&track->queue_empty);
> +
> +		spin_unlock_irqrestore(&track->queue_lock, flags);

Here we get a task from the head of the list and drop the lock, leaving
the task on the list...

> +		kfree(ptask);
> +
> +		if (empty)
> +			break;
> +
> +		track_process_task(track, task);

...we then go and do some other stuff, including processing that task,
without the lock or or any other means I can see of excluding other
users before going round and removing the task.  This seems to leave us
vulnerable to double execution.  I *think* this is supposed to be
handled by your comment "Provider should take care of calling
notifications synchronously in proper order" in the changelog but that's
a bit obscure, it's not specific about what the requirements are (or
what the limits are supposed to be on the notification callbacks).

I'm also unclear what is supposed to happen if adding a notification
races with removing the thing being watched.

--H8fFO+isr9ADh2Iv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUixmlAAoJECTWi3JdVIfQYzkH/2PSJ17rhazR845Aysdj33h4
A05VuTFXiQ8CO8EcV82HCkc+b3nTzdev8gmxCUIFf5F6VPPyHdbueAh3GCvvqYH8
XAN3WQLPfiSmf/hqKbhAM39SLF/xTUYkUlLsx4foKB6JK5ENvsCoS/M/i022cQfl
i5y7AruOzC+TAm70HQ/lKhDc5Xu3Pl25+thsVccYL3UUlCIZxiFpTyHueeA5IoTK
BWJ7uLVLNnq2ngPs+IZpwrl6LmybAp8WHwe+FOYvMeqQd2T5RGjroMfuvyOBGXsH
yHb/+Qbo3byiFrEjckIFKcK1RBrMb1kqEfvuhpwrIafC7hT6LqHPAT17rOeDlJg=
=TiBG
-----END PGP SIGNATURE-----

--H8fFO+isr9ADh2Iv--

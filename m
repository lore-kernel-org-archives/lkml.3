Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3FJUnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:43:23 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:52748 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3FJUnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:43:21 -0400
Date: Mon, 10 Jun 2013 22:43:17 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mayuresh Kulkarni <mkulkarni@nvidia.com>
Cc: Terje Bergstrom <tbergstrom@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/tegra: add support for runtime pm
Message-ID: <20130610204316.GC26036@mithrandir>
References: <1369662568-22390-1-git-send-email-mkulkarni@nvidia.com>
 <20130527154539.GD9460@mithrandir>
 <51A4445F.1000201@nvidia.com>
 <20130528091022.GB10934@mithrandir>
 <51ADA837.4020907@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c3bfwLpm8qysLVxt"
Content-Disposition: inline
In-Reply-To: <51ADA837.4020907@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 04, 2013 at 02:11:27PM +0530, Mayuresh Kulkarni wrote:
> On Tuesday 28 May 2013 02:40 PM, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Tue, May 28, 2013 at 08:45:03AM +0300, Terje Bergstr=C3=B6m wrote:
> >>On 27.05.2013 18:45, Thierry Reding wrote:
> >>>On Mon, May 27, 2013 at 07:19:28PM +0530, Mayuresh Kulkarni wrote:
> >>>>+#ifdef CONFIG_PM_RUNTIME
> >>>>+static int host1x_runtime_suspend(struct device *dev)
> >>>>+{
> >>>>+	struct host1x *host;
> >>>>+
> >>>>+	host =3D dev_get_drvdata(dev);
> >>>>+	if (IS_ERR_OR_NULL(host))
> >>>
> >>>I think a simple
> >>>
> >>>	if (!host)
> >>>		return -EINVAL;
> >>>
> >>>would be enough here. The driver-data of the device should never be an
> >>>ERR_PTR()-encoded value, but either a valid pointer to a host1x object
> >>>or NULL.
> >>
> >>True, we should avoid IS_ERR_OR_NULL() like plague. We always know if
> >>the called API returns a NULL on error or an error code. In case of
> >>error code we should just propagate that.
> >
> >Yes, that's the case in general. In this specific case the value
> >obtained by dev_get_drvdata() should either be a valid pointer or NULL,
> >never an error code. We can easily make sure by only setting the data
> >(using platform_set_drvdata()) when the pointer is valid.
> >
> >Thinking about it some more, I don't think we can ever get NULL here. A
> >device's .runtime_suspend() cannot be called when the device has been
> >removed, right? That's the only case where the value returned might be
> >NULL. It would be NULL too if host1x wasn't initialized yet, but that's
> >already dealt with by the proper ordering in .probe().
> >
> >>>Same comments apply here. Also I think it might be a good idea to split
> >>>the host1x and gr2d changes into separate patches.
> >>
> >>That's a bit tricky, but doable. We just need to enable it for 2D first,
> >>and then host1x to keep bisectability.
> >
> >Right, there's a dependency. But I'd still prefer to have them separate.
> >Unless it gets really messy.
> >
> >>>>  static void action_submit_complete(struct host1x_waitlist *waiter)
> >>>>  {
> >>>>+	int completed =3D waiter->count;
> >>>>  	struct host1x_channel *channel =3D waiter->data;
> >>>>
> >>>>+	/* disable clocks for all the submits that got completed in this lo=
t */
> >>>>+	while (completed--)
> >>>>+		pm_runtime_put(channel->dev);
> >>>>+
> >>>>  	host1x_cdma_update(&channel->cdma);
> >>>>
> >>>>-	/*  Add nr_completed to trace */
> >>>>+	/* Add nr_completed to trace */
> >>>>  	trace_host1x_channel_submit_complete(dev_name(channel->dev),
> >>>>  					     waiter->count, waiter->thresh);
> >>>>-
> >>>>  }
> >>>
> >>>This feels hackish. But I can't see any better place to do this. Terje,
> >>>Arto: any ideas how we can do this in a cleaner way? If there's nothing
> >>>better then maybe moving the code into a separate function, say
> >>>host1x_waitlist_complete(), might make this less awkward?
> >>
> >>Yeah, it's a bit awkward. action_submit_complete() actually does handle
> >>completion of multiple jobs, and we do one pm_runtime_get() per job.
> >>
> >>We could do pm_runtime_put() in host1x_cdma_update(). It anyway goes
> >>through each job that is completed, so while freeing the job it could as
> >>well call runtime PM. That way we could even remove the waiter->count
> >>variable altogether as it's not needed anymore.
> >
> >That sounds a lot better. We could add a helper (host1x_job_finish()
> >perhaps) with the following from update_cdma_locked():
> >
> >	/* Unpin the memory */
> >	host1x_job_unpin(job);
> >
> >	/* Pop push buffer slots */
> >	if (job->num_slots) {
> >		struct push_buffer *pb =3D &cdma->push_buffer;
> >		host1x_pushbuffer_pop(pb, job->num_slots);
> >		if (cdma->event =3D=3D CDMA_EVENT_PUSH_BUFFER_SPACE)
> >			signal =3D true;
> >	}
> >
> >	list_del(&job->list);
> >
> >And add pm_runtime_put() (as well as potentially other stuff) in there.
> >That'll prevent update_cdma_unlocked() from growing too much. It isn't
> >too bad right now, so maybe a helper isn't warranted yet, but I don't
> >think it'll hurt.
> >
> >>The not-so-beautiful aspect is that we do pm_runtime_get() in
> >>host1x_channel.c and pm_runtime_put() in host1x_cdma.c. For code
> >>readability it's be great to have them in the same file. I actually get
> >>questions every now and then because in downstream because of doing
> >>these operations in different files.
> >
> >With the above helper in place, we could move host1x_job_submit() to
> >job.c instead and have all the code in one file.
> >
> >Thierry
> >
> >* Unknown Key
> >* 0x7F3EB3A1
> >
>=20
> In downstream, we have 2 APIs which are wrapper over runtime PM
> calls. We call those from _submit and job complete.
>=20
> I wonder if we should follow the same here?

Can you post the corresponding wrappers to make it easier to discuss
them? If they just wrap runtime PM calls then they don't solve the
locality problems that Terje brought up.

Thierry

--c3bfwLpm8qysLVxt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtjpkAAoJEN0jrNd/PrOh8hkP/2sawkUFPFcWr4Xo/Ut0NX2u
rRywmD+0/X2pabBLEfi1+kdCMmff0aEu2Xb5irKj+BNqjwB6jZEV1jZNhdjjhqjj
LSmPqEOgDmK0v/vnP0tToS9z0N3RsmrasLHMGsavlumJWMGxB6ftpHD4kxMYJ182
KU8b1mEebIzBO+IM9v8Qn8C3Ud47EGKy5zlcgRQc0hZ1w9dNiYcLhMn+grKJYWdC
ejv2TQiQoWgT+aGYOd+7FRNx/BKprb1Dzm5oXRy6fzd3OSOSPNUr8q0H41u2vjBI
bh4l0ueA2zWt26QioxQUTF2hKZFxC8qQ/Zjx7dq/Zyhe739Beeu6f62IoZJdN+uV
pI55OxDEV43oaAucIw14xIMAMVs+gt8mvxfZ0/vKGlEDF2/n/hq/fRsSNKNsUowy
JK1l4hLM+Bkh7uT591Q+qI9YAS2eweEpHdnZEp4QZxc8XQ4ZtW8wCNPIoSmJ8ehs
e75DlZuRbclZekLTsGrc1EgjwiS/US3cETmPo09dXoWCsscDOiXH1HFmU7iUBgpw
hiMLoyJv6/+PO2newW/2qcdiR40O2MKlJts3JVFVGx2oU8CbmyKxpFWQjmRaWAyS
P52w6dm/u1p5Ut50ODGovPmWszjsF7qrbqjN3vo4pQq0oJe0qxtc2FObn2wG0oYp
4nhCdT34spMZo90J5vm/
=3h3y
-----END PGP SIGNATURE-----

--c3bfwLpm8qysLVxt--

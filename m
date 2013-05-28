Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738Ab3E1JK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:10:29 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:59226 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933615Ab3E1JK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:10:26 -0400
Date: Tue, 28 May 2013 11:10:23 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Mayuresh Kulkarni <mkulkarni@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/tegra: add support for runtime pm
Message-ID: <20130528091022.GB10934@mithrandir>
References: <1369662568-22390-1-git-send-email-mkulkarni@nvidia.com>
 <20130527154539.GD9460@mithrandir>
 <51A4445F.1000201@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <51A4445F.1000201@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2013 at 08:45:03AM +0300, Terje Bergstr=C3=B6m wrote:
> On 27.05.2013 18:45, Thierry Reding wrote:
> > On Mon, May 27, 2013 at 07:19:28PM +0530, Mayuresh Kulkarni wrote:
> >> +#ifdef CONFIG_PM_RUNTIME
> >> +static int host1x_runtime_suspend(struct device *dev)
> >> +{
> >> +	struct host1x *host;
> >> +
> >> +	host =3D dev_get_drvdata(dev);
> >> +	if (IS_ERR_OR_NULL(host))
> >=20
> > I think a simple
> >=20
> > 	if (!host)
> > 		return -EINVAL;
> >=20
> > would be enough here. The driver-data of the device should never be an
> > ERR_PTR()-encoded value, but either a valid pointer to a host1x object
> > or NULL.
>=20
> True, we should avoid IS_ERR_OR_NULL() like plague. We always know if
> the called API returns a NULL on error or an error code. In case of
> error code we should just propagate that.

Yes, that's the case in general. In this specific case the value
obtained by dev_get_drvdata() should either be a valid pointer or NULL,
never an error code. We can easily make sure by only setting the data
(using platform_set_drvdata()) when the pointer is valid.

Thinking about it some more, I don't think we can ever get NULL here. A
device's .runtime_suspend() cannot be called when the device has been
removed, right? That's the only case where the value returned might be
NULL. It would be NULL too if host1x wasn't initialized yet, but that's
already dealt with by the proper ordering in .probe().

> > Same comments apply here. Also I think it might be a good idea to split
> > the host1x and gr2d changes into separate patches.
>=20
> That's a bit tricky, but doable. We just need to enable it for 2D first,
> and then host1x to keep bisectability.

Right, there's a dependency. But I'd still prefer to have them separate.
Unless it gets really messy.

> >>  static void action_submit_complete(struct host1x_waitlist *waiter)
> >>  {
> >> +	int completed =3D waiter->count;
> >>  	struct host1x_channel *channel =3D waiter->data;
> >> =20
> >> +	/* disable clocks for all the submits that got completed in this lot=
 */
> >> +	while (completed--)
> >> +		pm_runtime_put(channel->dev);
> >> +
> >>  	host1x_cdma_update(&channel->cdma);
> >> =20
> >> -	/*  Add nr_completed to trace */
> >> +	/* Add nr_completed to trace */
> >>  	trace_host1x_channel_submit_complete(dev_name(channel->dev),
> >>  					     waiter->count, waiter->thresh);
> >> -
> >>  }
> >=20
> > This feels hackish. But I can't see any better place to do this. Terje,
> > Arto: any ideas how we can do this in a cleaner way? If there's nothing
> > better then maybe moving the code into a separate function, say
> > host1x_waitlist_complete(), might make this less awkward?
>=20
> Yeah, it's a bit awkward. action_submit_complete() actually does handle
> completion of multiple jobs, and we do one pm_runtime_get() per job.
>=20
> We could do pm_runtime_put() in host1x_cdma_update(). It anyway goes
> through each job that is completed, so while freeing the job it could as
> well call runtime PM. That way we could even remove the waiter->count
> variable altogether as it's not needed anymore.

That sounds a lot better. We could add a helper (host1x_job_finish()
perhaps) with the following from update_cdma_locked():

	/* Unpin the memory */
	host1x_job_unpin(job);

	/* Pop push buffer slots */
	if (job->num_slots) {
		struct push_buffer *pb =3D &cdma->push_buffer;
		host1x_pushbuffer_pop(pb, job->num_slots);
		if (cdma->event =3D=3D CDMA_EVENT_PUSH_BUFFER_SPACE)
			signal =3D true;
	}

	list_del(&job->list);

And add pm_runtime_put() (as well as potentially other stuff) in there.
That'll prevent update_cdma_unlocked() from growing too much. It isn't
too bad right now, so maybe a helper isn't warranted yet, but I don't
think it'll hurt.

> The not-so-beautiful aspect is that we do pm_runtime_get() in
> host1x_channel.c and pm_runtime_put() in host1x_cdma.c. For code
> readability it's be great to have them in the same file. I actually get
> questions every now and then because in downstream because of doing
> these operations in different files.

With the above helper in place, we could move host1x_job_submit() to
job.c instead and have all the code in one file.

Thierry

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRpHR+AAoJEN0jrNd/PrOhUHIQALQfZJzK+1pMQcEWUHgyl1ZT
FNLR/HraP33hKq6RCC5PAbmJsTS9NC6qJ0kcr5CmFpdixgqYY419CR4HDnftRlz5
0Cw2q4AOGx1lunYkIpR0iQBc1YEwuAHFJAaJi4zQ9RHmdJCMBT80S8E38m5eZ35Y
kytxZfeh9YrEDPV6I1XeHEJzjFAIsDmgTKkpwMxxToZlxNPi7Q9pNeLbKJVoeBf0
RKNLFRoyL8I0eFBbW2V76tj2e5f5SbuGGrnL9dNFflMCupLxMMNWpOjryAXdH4lP
OUxfqSBP+f6ay4Zjm6m8YJm9TIG3ztq9zIurejSbcYwQp494yAeW+GLnpLinqjvy
aZltCCKiNJ4Lk5OqfV+uj9rwNbW8ou34dHPe/U0oBKZ+sB7oDSoaTvT9O5sdHHDL
3CsRl4QcYsyf86jaFl/ng5MyBLDb0alUZbYko9jygUP6eVp+L01uUwNeTbW7GoYr
U2D+Qrc+ZAahmo/Z5trKmYNRyJBk3hm/coZLyJzXRJcHy3iRV/bG9VhMaDOQxpqy
cReU6+YE9u5+R4cf5FvgPzGkrCq7vwOzPORsJ/XodrQytCIn4kZN+BoK9l3jLtRn
E/t9YZ7/ozJlf7ip9lR6EC33rL+q2gZxPzFECTcnumKHTE6Z6pczePyCdtT4E3k5
nBt0CiY8vMv7XbOW+KQo
=lnTr
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--

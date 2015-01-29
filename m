Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbbA2CR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:17:27 -0500
Received: from ozlabs.org ([103.22.144.67]:39577 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757719AbbA2CRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:17:25 -0500
Date: Thu, 29 Jan 2015 13:17:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oded Gabbay <oded.gabbay@amd.com>, Ben Goz <ben.goz@amd.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-ID: <20150129131718.645dbb99@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/S9vo1trcbAYX6d7HJA79wce"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/S9vo1trcbAYX6d7HJA79wce
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got conflicts in
drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c and
drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h between commits
b8cbab042cd6 ("drm/amdkfd: Allow user to limit only queues per device")
and 9fa843e76d90 ("drm/amdkfd: Fix bug in call to init_pipelines()")
from Linus' tree and commits bcea30817574 ("drm/amdkfd: Add SDMA
user-mode queues support to QCM") and fe502804205e ("drm/amdkfd: Remove
call to deprecated init_memory interface") from the drm tree.

I fixed it up (hopefully - see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 0d8694f015c1,b189f9791c90..000000000000
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@@ -213,15 -161,8 +168,18 @@@ static int create_queue_nocpsch(struct=20
 =20
  	list_add(&q->list, &qpd->queues_list);
  	dqm->queue_count++;
 +
 +	/*
 +	 * Unconditionally increment this counter, regardless of the queue's
 +	 * type or whether the queue is active.
 +	 */
 +	dqm->total_queue_count++;
 +	pr_debug("Total of %d queues are accountable so far\n",
 +			dqm->total_queue_count);
 +
++
+ 	if (q->properties.type =3D=3D KFD_QUEUE_TYPE_SDMA)
+ 		dqm->sdma_queue_count++;
  	mutex_unlock(&dqm->lock);
  	return 0;
  }
@@@ -588,11 -488,7 +518,7 @@@ static int init_scheduler(struct device
 =20
  	pr_debug("kfd: In %s\n", __func__);
 =20
 -	retval =3D init_pipelines(dqm, get_pipes_num(dqm), KFD_DQM_FIRST_PIPE);
 +	retval =3D init_pipelines(dqm, get_pipes_num(dqm), get_first_pipe(dqm));
- 	if (retval !=3D 0)
- 		return retval;
-=20
- 	retval =3D init_memory(dqm);
 =20
  	return retval;
  }
@@@ -843,14 -793,12 +845,19 @@@ static int create_queue_cpsch(struct de
 =20
  	mutex_lock(&dqm->lock);
 =20
 +	if (dqm->total_queue_count >=3D max_num_of_queues_per_device) {
 +		pr_warn("amdkfd: Can't create new usermode queue because %d queues were=
 already created\n",
 +				dqm->total_queue_count);
 +		retval =3D -EPERM;
 +		goto out;
 +	}
 +
- 	mqd =3D dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_CP);
+ 	if (q->properties.type =3D=3D KFD_QUEUE_TYPE_SDMA)
+ 		select_sdma_engine_id(q);
+=20
+ 	mqd =3D dqm->ops.get_mqd_manager(dqm,
+ 			get_mqd_type_from_queue_type(q->properties.type));
+=20
  	if (mqd =3D=3D NULL) {
  		mutex_unlock(&dqm->lock);
  		return -ENOMEM;
@@@ -867,15 -815,9 +874,18 @@@
  		retval =3D execute_queues_cpsch(dqm, false);
  	}
 =20
 +	/*
 +	 * Unconditionally increment this counter, regardless of the queue's
 +	 * type or whether the queue is active.
 +	 */
 +	dqm->total_queue_count++;
 +
 +	pr_debug("Total of %d queues are accountable so far\n",
 +			dqm->total_queue_count);
 +
+ 	if (q->properties.type =3D=3D KFD_QUEUE_TYPE_SDMA)
+ 			dqm->sdma_queue_count++;
+=20
  out:
  	mutex_unlock(&dqm->lock);
  	return retval;
diff --cc drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
index 52035bf0c1cb,e7b17b28330e..000000000000
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
@@@ -130,9 -143,10 +143,11 @@@ struct device_queue_manager=20
  	struct list_head	queues;
  	unsigned int		processes_count;
  	unsigned int		queue_count;
 +	unsigned int		total_queue_count;
+ 	unsigned int		sdma_queue_count;
  	unsigned int		next_pipe_to_allocate;
  	unsigned int		*allocated_queues;
+ 	unsigned int		sdma_bitmap;
  	unsigned int		vmid_bitmap;
  	uint64_t		pipelines_addr;
  	struct kfd_mem_obj	*pipeline_mem;

--Sig_/S9vo1trcbAYX6d7HJA79wce
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUyZgzAAoJEMDTa8Ir7ZwVhBYQAJdBgmBOL70vAc1YStor/Kfz
hG/9aXR1jOnEi73yzVgBrOp685QY1dN7dQAkliRc64KCGLcE4NXXHqRzUsKgXEqz
OYomOt1OILOw9c2PFchTVMZ6rJRDb29T4SSzzH2RWruX2+awYTF+IU2RfYNtoeV9
vbXmDPuMxWITYQ+xuDfhnU/+bjYP0NBfW1EQ7tFUi/+0BLDx27yIXeEshgHL5q2l
NTvQ0DYKoVKwtKsGInoRXYl34bGFvmAbEP9dLOIKZYsb7/UKO5+73WRsTKlIz2BP
ZASUhH7hFtDw1XQegTTTl3Gm5I8fWAp9tmDsyb5g6fu3KPF5CE1KOKbiQNcUQO8N
TcCVVRa5AwHmyrSjyFytw+g5fxka2X40EqTPG0lhhE6NY/gpVJUN9pS/P5N6YNPV
H56yQQq+HUvpGTamnjNJSKiNUrsxyfhRa9b17i4s2II8nDVa9qCPmL2i5KrJqZWU
i6veNEvao9N6qZSy9abz34IBaFUjw46J+k9H9mhkPVCcFZDhYkbRGWzUCCbXHji1
gGbgSTsydkV3pUtJ3831Rboj0pU8UDN+mgL6KQX3J/K5nUlNg5leSVAhsZJmkIu+
uFy2YCxHr3mTK41rOB/qsWDPi9UQJvg8kBF0MiICo/7wUktJ56qxpN7JIdT6EclM
4+hX7LtNndB897bCTKKK
=xNR8
-----END PGP SIGNATURE-----

--Sig_/S9vo1trcbAYX6d7HJA79wce--

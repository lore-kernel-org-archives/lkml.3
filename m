Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaANEvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:51:15 -0500
Received: from ozlabs.org ([203.10.76.45]:38412 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbaANEvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:51:13 -0500
Date: Tue, 14 Jan 2014 15:51:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Munsie <imunsie@au1.ibm.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: linux-next: manual merge of the akpm-current tree with the
 char-misc tree
Message-Id: <20140114155104.0ab2772aaa909e49bc89cd61@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__14_Jan_2014_15_51_04_+1100_mW22lnhlUI2Nc4fc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Jan_2014_15_51_04_+1100_mW22lnhlUI2Nc4fc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
drivers/misc/mei/init.c between commit 33ec08263147 ("mei: revamp mei
reset state machine") from the char-misc tree and commit dd045dab2999
("drivers/misc/mei: ratelimit several error messages") from the
akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/misc/mei/init.c
index cdd31c2a2a2b,edd3bb6a5df9..000000000000
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@@ -43,119 -43,41 +43,119 @@@ const char *mei_dev_state_str(int state
  #undef MEI_DEV_STATE
  }
 =20
 -void mei_device_init(struct mei_device *dev)
 -{
 -	/* setup our list array */
 -	INIT_LIST_HEAD(&dev->file_list);
 -	INIT_LIST_HEAD(&dev->device_list);
 -	mutex_init(&dev->device_lock);
 -	init_waitqueue_head(&dev->wait_hw_ready);
 -	init_waitqueue_head(&dev->wait_recvd_msg);
 -	init_waitqueue_head(&dev->wait_stop_wd);
 -	dev->dev_state =3D MEI_DEV_INITIALIZING;
 =20
 -	mei_io_list_init(&dev->read_list);
 -	mei_io_list_init(&dev->write_list);
 -	mei_io_list_init(&dev->write_waiting_list);
 -	mei_io_list_init(&dev->ctrl_wr_list);
 -	mei_io_list_init(&dev->ctrl_rd_list);
 +/**
 + * mei_cancel_work. Cancel mei background jobs
 + *
 + * @dev: the device structure
 + *
 + * returns 0 on success or < 0 if the reset hasn't succeeded
 + */
 +void mei_cancel_work(struct mei_device *dev)
 +{
 +	cancel_work_sync(&dev->init_work);
 +	cancel_work_sync(&dev->reset_work);
 =20
 -	INIT_DELAYED_WORK(&dev->timer_work, mei_timer);
 -	INIT_WORK(&dev->init_work, mei_host_client_init);
 +	cancel_delayed_work(&dev->timer_work);
 +}
 +EXPORT_SYMBOL_GPL(mei_cancel_work);
 =20
 -	INIT_LIST_HEAD(&dev->wd_cl.link);
 -	INIT_LIST_HEAD(&dev->iamthif_cl.link);
 -	mei_io_list_init(&dev->amthif_cmd_list);
 -	mei_io_list_init(&dev->amthif_rd_complete_list);
 +/**
 + * mei_reset - resets host and fw.
 + *
 + * @dev: the device structure
 + */
 +int mei_reset(struct mei_device *dev)
 +{
 +	enum mei_dev_state state =3D dev->dev_state;
 +	bool interrupts_enabled;
 +	int ret;
 =20
 -	bitmap_zero(dev->host_clients_map, MEI_CLIENTS_MAX);
 -	dev->open_handle_count =3D 0;
 +	if (state !=3D MEI_DEV_INITIALIZING &&
 +	    state !=3D MEI_DEV_DISABLED &&
 +	    state !=3D MEI_DEV_POWER_DOWN &&
 +	    state !=3D MEI_DEV_POWER_UP)
- 		dev_warn(&dev->pdev->dev, "unexpected reset: dev_state =3D %s\n",
++		dev_warn_ratelimited(&dev->pdev->dev, "unexpected reset: dev_state =3D =
%s\n",
 +			 mei_dev_state_str(state));
 =20
 -	/*
 -	 * Reserving the first client ID
 -	 * 0: Reserved for MEI Bus Message communications
 +	/* we're already in reset, cancel the init timer
 +	 * if the reset was called due the hbm protocol error
 +	 * we need to call it before hw start
 +	 * so the hbm watchdog won't kick in
  	 */
 -	bitmap_set(dev->host_clients_map, 0, 1);
 +	mei_hbm_idle(dev);
 +
 +	/* enter reset flow */
 +	interrupts_enabled =3D state !=3D MEI_DEV_POWER_DOWN;
 +	dev->dev_state =3D MEI_DEV_RESETTING;
 +
 +	dev->reset_count++;
 +	if (dev->reset_count > MEI_MAX_CONSEC_RESET) {
 +		dev_err(&dev->pdev->dev, "reset: reached maximal consecutive resets: di=
sabling the device\n");
 +		dev->dev_state =3D MEI_DEV_DISABLED;
 +		return -ENODEV;
 +	}
 +
 +	ret =3D mei_hw_reset(dev, interrupts_enabled);
 +	/* fall through and remove the sw state even if hw reset has failed */
 +
 +	/* no need to clean up software state in case of power up */
 +	if (state !=3D MEI_DEV_INITIALIZING &&
 +	    state !=3D MEI_DEV_POWER_UP) {
 +
 +		/* remove all waiting requests */
 +		mei_cl_all_write_clear(dev);
 +
 +		mei_cl_all_disconnect(dev);
 +
 +		/* wake up all readers and writers so they can be interrupted */
 +		mei_cl_all_wakeup(dev);
 +
 +		/* remove entry if already in list */
 +		dev_dbg(&dev->pdev->dev, "remove iamthif and wd from the file list.\n");
 +		mei_cl_unlink(&dev->wd_cl);
 +		mei_cl_unlink(&dev->iamthif_cl);
 +		mei_amthif_reset_params(dev);
 +		memset(&dev->wr_ext_msg, 0, sizeof(dev->wr_ext_msg));
 +	}
 +
 +
 +	dev->me_clients_num =3D 0;
 +	dev->rd_msg_hdr =3D 0;
 +	dev->wd_pending =3D false;
 +
 +	if (ret) {
 +		dev_err(&dev->pdev->dev, "hw_reset failed ret =3D %d\n", ret);
 +		dev->dev_state =3D MEI_DEV_DISABLED;
 +		return ret;
 +	}
 +
 +	if (state =3D=3D MEI_DEV_POWER_DOWN) {
 +		dev_dbg(&dev->pdev->dev, "powering down: end of reset\n");
 +		dev->dev_state =3D MEI_DEV_DISABLED;
 +		return 0;
 +	}
 +
 +	ret =3D mei_hw_start(dev);
 +	if (ret) {
 +		dev_err(&dev->pdev->dev, "hw_start failed ret =3D %d\n", ret);
 +		dev->dev_state =3D MEI_DEV_DISABLED;
 +		return ret;
 +	}
 +
 +	dev_dbg(&dev->pdev->dev, "link is established start sending messages.\n"=
);
 +
 +	dev->dev_state =3D MEI_DEV_INIT_CLIENTS;
 +	ret =3D mei_hbm_start_req(dev);
 +	if (ret) {
 +		dev_err(&dev->pdev->dev, "hbm_start failed ret =3D %d\n", ret);
 +		dev->dev_state =3D MEI_DEV_DISABLED;
 +		return ret;
 +	}
 +
 +	return 0;
  }
 -EXPORT_SYMBOL_GPL(mei_device_init);
 +EXPORT_SYMBOL_GPL(mei_reset);
 =20
  /**
   * mei_start - initializes host and fw to start work.

--Signature=_Tue__14_Jan_2014_15_51_04_+1100_mW22lnhlUI2Nc4fc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1MI9AAoJEMDTa8Ir7ZwVYRkP/jjDGTsxRGSizZ1b70EGpB+U
dg5y6AVb9bjL5WlFdm6PH5gxHY315EiVhm8IHPcLlyPPae8ePp4MyNGaSlvsG1s8
ygpuoeEBLLkpMslimLFcJPNiWDNich88j2PokFTy4Vae55qWo+C90KaiHgjcKstp
l3qQqQXkr2vlVNHqKdMSWdSdNMfeMuFBBt4dn6QNS6AHNsxF7iM99kV1AcTuwP5O
xCGkZYQEz+gNCzSb9MwMX4GDwYteVCA7t4R4QBDdIfSuPYDSgJAPprQUlXNMto3l
KJnRgeM6ilNcHteYzTWDoLLa0MWo8X0OfkzDdm3vv/Rzkt2XHEpqnAbGozdXHn3y
sXC94Fdj8mjH7uiA/5VcvsF85jeodPWh3rZLe72bKHCkkX0PoAJM7am0BSwyQ6CC
mc7ZGYgb1+3tfuBTlJ8kEutMCy7TKSJyE8iSctYqNB87WAby7uuIo6O1QILGsmPB
3Vh26GGGwqPIf10UMpb0XqWURiXWTiDDlHzjqyKKwc3irOOFkWd/JvKSGHQUPuOx
jTSmzRfkrPBVv7EUMVCKuAC/zOqR3Zn3cY461kPEmJ9iEYtlKG3gzV2GW72EJm9i
C2tSqklWKFr3z3uhECmxCbWP0gKn7rRExfENXz+WmMKMT4BSz1oe8CzCXcG3uxE1
KFp18tB+SHBkx7toB4rX
=3kOu
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Jan_2014_15_51_04_+1100_mW22lnhlUI2Nc4fc--

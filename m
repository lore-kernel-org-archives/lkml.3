Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaIGQWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 12:22:50 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44979
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbaIGQWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 12:22:32 -0400
X-IronPort-AV: E=Sophos;i="5.04,483,1406584800"; 
   d="scan'208";a="78047708"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 7/7] staging: lustre: obdclass: expand the GOTO macro
Date: Sun,  7 Sep 2014 18:18:35 +0200
Message-Id: <1410106715-9573-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier lbl;
identifier rc;
constant c;
@@

- GOTO(lbl,\(rc\|c\));
+ goto lbl;

@@
identifier lbl;
expression rc;
@@

- GOTO(lbl,rc);
+ rc;
+ goto lbl;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/lustre/obdclass/acl.c            |   27 ++-
 drivers/staging/lustre/lustre/obdclass/capa.c           |   14 +
 drivers/staging/lustre/lustre/obdclass/cl_lock.c        |    2 
 drivers/staging/lustre/lustre/obdclass/class_obd.c      |   98 ++++++++-----
 drivers/staging/lustre/lustre/obdclass/dt_object.c      |   50 ++++--
 drivers/staging/lustre/lustre/obdclass/genops.c         |   45 +++---
 drivers/staging/lustre/lustre/obdclass/llog.c           |   80 ++++++----
 drivers/staging/lustre/lustre/obdclass/llog_cat.c       |   17 +-
 drivers/staging/lustre/lustre/obdclass/llog_ioctl.c     |   45 +++---
 drivers/staging/lustre/lustre/obdclass/local_storage.c  |  102 ++++++++-----
 drivers/staging/lustre/lustre/obdclass/lprocfs_status.c |   21 +-
 drivers/staging/lustre/lustre/obdclass/obd_config.c     |  120 ++++++++++------
 drivers/staging/lustre/lustre/obdclass/obd_mount.c      |   50 ++++--
 13 files changed, 413 insertions(+), 258 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/acl.c b/drivers/staging/lustre/lustre/obdclass/acl.c
index 3b394a0..2619bfe 100644
--- a/drivers/staging/lustre/lustre/obdclass/acl.c
+++ b/drivers/staging/lustre/lustre/obdclass/acl.c
@@ -196,8 +196,10 @@ int lustre_posix_acl_xattr_filter(posix_acl_xattr_header *header, int size,
 		case ACL_GROUP_OBJ:
 		case ACL_MASK:
 		case ACL_OTHER:
-			if (id != ACL_UNDEFINED_ID)
-				GOTO(_out, rc = -EIO);
+			if (id != ACL_UNDEFINED_ID) {
+				rc = -EIO;
+				goto _out;
+			}
 
 			memcpy(&new->a_entries[j++], &header->a_entries[i],
 			       sizeof(posix_acl_xattr_entry));
@@ -215,7 +217,8 @@ int lustre_posix_acl_xattr_filter(posix_acl_xattr_header *header, int size,
 				       sizeof(posix_acl_xattr_entry));
 			break;
 		default:
-			GOTO(_out, rc = -EIO);
+			rc = -EIO;
+			goto _out;
 		}
 	}
 
@@ -318,8 +321,10 @@ int lustre_acl_xattr_merge2posix(posix_acl_xattr_header *posix_header, int size,
 			case ACL_USER_OBJ:
 			case ACL_GROUP_OBJ:
 			case ACL_OTHER:
-				if (ae.e_id != ACL_UNDEFINED_ID)
-					GOTO(_out, rc = -EIO);
+				if (ae.e_id != ACL_UNDEFINED_ID) {
+					rc = -EIO;
+					goto _out;
+				}
 
 				if (ae.e_stat != ES_DEL) {
 					new->a_entries[j].e_tag =
@@ -336,7 +341,8 @@ int lustre_acl_xattr_merge2posix(posix_acl_xattr_header *posix_header, int size,
 				if (ae.e_stat == ES_DEL)
 					break;
 			default:
-				GOTO(_out, rc = -EIO);
+				rc = -EIO;
+				goto _out;
 			}
 		}
 	} else {
@@ -437,8 +443,10 @@ lustre_acl_xattr_merge2ext(posix_acl_xattr_header *posix_header, int size,
 		case ACL_GROUP_OBJ:
 		case ACL_MASK:
 		case ACL_OTHER:
-			if (pae.e_id != ACL_UNDEFINED_ID)
-				GOTO(out, rc = -EIO);
+			if (pae.e_id != ACL_UNDEFINED_ID) {
+				rc = -EIO;
+				goto out;
+		}
 		case ACL_USER:
 			/* ignore "nobody" entry. */
 			if (pae.e_id == NOBODY_UID)
@@ -501,7 +509,8 @@ lustre_acl_xattr_merge2ext(posix_acl_xattr_header *posix_header, int size,
 			}
 			break;
 		default:
-			GOTO(out, rc = -EIO);
+			rc = -EIO;
+			goto out;
 		}
 	}
 
diff --git a/drivers/staging/lustre/lustre/obdclass/capa.c b/drivers/staging/lustre/lustre/obdclass/capa.c
index 5af61a8..6a4b4d7 100644
--- a/drivers/staging/lustre/lustre/obdclass/capa.c
+++ b/drivers/staging/lustre/lustre/obdclass/capa.c
@@ -312,13 +312,14 @@ int capa_encrypt_id(__u32 *d, __u32 *s, __u8 *key, int keylen)
 	min = ll_crypto_tfm_alg_min_keysize(tfm);
 	if (keylen < min) {
 		CERROR("keylen at least %d bits for aes\n", min * 8);
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}
 
 	rc = crypto_blkcipher_setkey(tfm, key, min);
 	if (rc) {
 		CERROR("failed to setting key for aes\n");
-		GOTO(out, rc);
+		goto out;
 	}
 
 	sg_init_table(&sd, 1);
@@ -334,7 +335,7 @@ int capa_encrypt_id(__u32 *d, __u32 *s, __u8 *key, int keylen)
 	rc = crypto_blkcipher_encrypt(&desc, &sd, &ss, 16);
 	if (rc) {
 		CERROR("failed to encrypt for aes\n");
-		GOTO(out, rc);
+		goto out;
 	}
 
 out:
@@ -364,13 +365,14 @@ int capa_decrypt_id(__u32 *d, __u32 *s, __u8 *key, int keylen)
 	min = ll_crypto_tfm_alg_min_keysize(tfm);
 	if (keylen < min) {
 		CERROR("keylen at least %d bits for aes\n", min * 8);
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}
 
 	rc = crypto_blkcipher_setkey(tfm, key, min);
 	if (rc) {
 		CERROR("failed to setting key for aes\n");
-		GOTO(out, rc);
+		goto out;
 	}
 
 	sg_init_table(&sd, 1);
@@ -387,7 +389,7 @@ int capa_decrypt_id(__u32 *d, __u32 *s, __u8 *key, int keylen)
 	rc = crypto_blkcipher_decrypt(&desc, &sd, &ss, 16);
 	if (rc) {
 		CERROR("failed to decrypt for aes\n");
-		GOTO(out, rc);
+		goto out;
 	}
 
 out:
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_lock.c b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
index 7d99319..b204531 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_lock.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
@@ -1938,7 +1938,7 @@ int cl_lock_discard_pages(const struct lu_env *env, struct cl_lock *lock)
 	io->ci_ignore_layout = 1;
 	result = cl_io_init(env, io, CIT_MISC, io->ci_obj);
 	if (result != 0)
-		GOTO(out, result);
+		goto out;
 
 	cb = descr->cld_mode == CLM_READ ? check_and_discard_cb : discard_cb;
 	info->clt_fn_index = info->clt_next_index = descr->cld_start;
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index a73eb76..8b8d338 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -177,18 +177,21 @@ int class_resolve_dev_name(__u32 len, const char *name)
 
 	if (!len || !name) {
 		CERROR("No name passed,!\n");
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}
 	if (name[len - 1] != 0) {
 		CERROR("Name not nul terminated!\n");
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}
 
 	CDEBUG(D_IOCTL, "device name %s\n", name);
 	dev = class_name2dev(name);
 	if (dev == -1) {
 		CDEBUG(D_IOCTL, "No device for name %s!\n", name);
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}
 
 	CDEBUG(D_IOCTL, "device name %s, dev %d\n", name, dev);
@@ -227,11 +230,14 @@ int class_handle_ioctl(unsigned int cmd, unsigned long arg)
 
 		if (!data->ioc_plen1 || !data->ioc_pbuf1) {
 			CERROR("No config buffer passed!\n");
-			GOTO(out, err = -EINVAL);
+			err = -EINVAL;
+			goto out;
 		}
 		OBD_ALLOC(lcfg, data->ioc_plen1);
-		if (lcfg == NULL)
-			GOTO(out, err = -ENOMEM);
+		if (lcfg == NULL) {
+			err = -ENOMEM;
+			goto out;
+		}
 		err = copy_from_user(lcfg, data->ioc_pbuf1,
 					 data->ioc_plen1);
 		if (!err)
@@ -240,18 +246,20 @@ int class_handle_ioctl(unsigned int cmd, unsigned long arg)
 			err = class_process_config(lcfg);
 
 		OBD_FREE(lcfg, data->ioc_plen1);
-		GOTO(out, err);
+		goto out;
 	}
 
 	case OBD_GET_VERSION:
 		if (!data->ioc_inlbuf1) {
 			CERROR("No buffer passed in ioctl\n");
-			GOTO(out, err = -EINVAL);
+			err = -EINVAL;
+			goto out;
 		}
 
 		if (strlen(BUILD_VERSION) + 1 > data->ioc_inllen1) {
 			CERROR("ioctl buffer too small to hold version\n");
-			GOTO(out, err = -EINVAL);
+			err = -EINVAL;
+			goto out;
 		}
 
 		memcpy(data->ioc_bulk, BUILD_VERSION,
@@ -260,7 +268,7 @@ int class_handle_ioctl(unsigned int cmd, unsigned long arg)
 		err = obd_ioctl_popdata((void *)arg, data, len);
 		if (err)
 			err = -EFAULT;
-		GOTO(out, err);
+		goto out;
 
 	case OBD_IOC_NAME2DEV: {
 		/* Resolve a device name.  This does not change the
@@ -271,13 +279,15 @@ int class_handle_ioctl(unsigned int cmd, unsigned long arg)
 		dev = class_resolve_dev_name(data->ioc_inllen1,
 					     data->ioc_inlbuf1);
 		data->ioc_dev = dev;
-		if (dev < 0)
-			GOTO(out, err = -EINVAL);
+		if (dev < 0) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		err = obd_ioctl_popdata((void *)arg, data, sizeof(*data));
 		if (err)
 			err = -EFAULT;
-		GOTO(out, err);
+		goto out;
 	}
 
 	case OBD_IOC_UUID2DEV: {
@@ -289,11 +299,13 @@ int class_handle_ioctl(unsigned int cmd, unsigned long arg)
 
 		if (!data->ioc_inllen1 || !data->ioc_inlbuf1) {
 			CERROR("No UUID passed!\n");
-			GOTO(out, err = -EINVAL);
+			err = -EINVAL;
+			goto out;
 		}
 		if (data->ioc_inlbuf1[data->ioc_inllen1 - 1] != 0) {
 			CERROR("UUID not NUL terminated!\n");
-			GOTO(out, err = -EINVAL);
+			err = -EINVAL;
+			goto out;
 		}
 
 		CDEBUG(D_IOCTL, "device name %s\n", data->ioc_inlbuf1);
@@ -303,7 +315,8 @@ int class_handle_ioctl(unsigned int cmd, unsigned long arg)
 		if (dev == -1) {
 			CDEBUG(D_IOCTL, "No device for UUID %s!\n",
 			       data->ioc_inlbuf1);
-			GOTO(out, err = -EINVAL);
+			err = -EINVAL;
+			goto out;
 		}
 
 		CDEBUG(D_IOCTL, "device name %s, dev %d\n", data->ioc_inlbuf1,
@@ -311,13 +324,14 @@ int class_handle_ioctl(unsigned int cmd, unsigned long arg)
 		err = obd_ioctl_popdata((void *)arg, data, sizeof(*data));
 		if (err)
 			err = -EFAULT;
-		GOTO(out, err);
+		goto out;
 	}
 
 	case OBD_IOC_CLOSE_UUID: {
 		CDEBUG(D_IOCTL, "closing all connections to uuid %s (NOOP)\n",
 		       data->ioc_inlbuf1);
-		GOTO(out, err = 0);
+		err = 0;
+		goto out;
 	}
 
 	case OBD_IOC_GETDEVICE: {
@@ -326,16 +340,20 @@ int class_handle_ioctl(unsigned int cmd, unsigned long arg)
 
 		if (!data->ioc_inlbuf1) {
 			CERROR("No buffer passed in ioctl\n");
-			GOTO(out, err = -EINVAL);
+			err = -EINVAL;
+			goto out;
 		}
 		if (data->ioc_inllen1 < 128) {
 			CERROR("ioctl buffer too small to hold version\n");
-			GOTO(out, err = -EINVAL);
+			err = -EINVAL;
+			goto out;
 		}
 
 		obd = class_num2obd(index);
-		if (!obd)
-			GOTO(out, err = -ENOENT);
+		if (!obd) {
+			err = -ENOENT;
+			goto out;
+		}
 
 		if (obd->obd_stopping)
 			status = "ST";
@@ -352,56 +370,66 @@ int class_handle_ioctl(unsigned int cmd, unsigned long arg)
 			 atomic_read(&obd->obd_refcount));
 		err = obd_ioctl_popdata((void *)arg, data, len);
 
-		GOTO(out, err = 0);
+		err = 0;
+		goto out;
 	}
 
 	}
 
 	if (data->ioc_dev == OBD_DEV_BY_DEVNAME) {
-		if (data->ioc_inllen4 <= 0 || data->ioc_inlbuf4 == NULL)
-			GOTO(out, err = -EINVAL);
-		if (strnlen(data->ioc_inlbuf4, MAX_OBD_NAME) >= MAX_OBD_NAME)
-			GOTO(out, err = -EINVAL);
+		if (data->ioc_inllen4 <= 0 || data->ioc_inlbuf4 == NULL) {
+			err = -EINVAL;
+			goto out;
+		}
+		if (strnlen(data->ioc_inlbuf4, MAX_OBD_NAME) >= MAX_OBD_NAME) {
+			err = -EINVAL;
+			goto out;
+		}
 		obd = class_name2obd(data->ioc_inlbuf4);
 	} else if (data->ioc_dev < class_devno_max()) {
 		obd = class_num2obd(data->ioc_dev);
 	} else {
 		CERROR("OBD ioctl: No device\n");
-		GOTO(out, err = -EINVAL);
+		err = -EINVAL;
+		goto out;
 	}
 
 	if (obd == NULL) {
 		CERROR("OBD ioctl : No Device %d\n", data->ioc_dev);
-		GOTO(out, err = -EINVAL);
+		err = -EINVAL;
+		goto out;
 	}
 	LASSERT(obd->obd_magic == OBD_DEVICE_MAGIC);
 
 	if (!obd->obd_set_up || obd->obd_stopping) {
-		CERROR("OBD ioctl: device not setup %d \n", data->ioc_dev);
-		GOTO(out, err = -EINVAL);
+		CERROR("OBD ioctl: device not setup %d\n", data->ioc_dev);
+		err = -EINVAL;
+		goto out;
 	}
 
 	switch (cmd) {
 	case OBD_IOC_NO_TRANSNO: {
 		if (!obd->obd_attached) {
 			CERROR("Device %d not attached\n", obd->obd_minor);
-			GOTO(out, err = -ENODEV);
+			err = -ENODEV;
+			goto out;
 		}
 		CDEBUG(D_HA, "%s: disabling committed-transno notification\n",
 		       obd->obd_name);
 		obd->obd_no_transno = 1;
-		GOTO(out, err = 0);
+		err = 0;
+		goto out;
 	}
 
 	default: {
 		err = obd_iocontrol(cmd, obd->obd_self_export, len, data, NULL);
 		if (err)
-			GOTO(out, err);
+			goto out;
 
 		err = obd_ioctl_popdata((void *)arg, data, len);
 		if (err)
 			err = -EFAULT;
-		GOTO(out, err);
+		goto out;
 	}
 	}
 
diff --git a/drivers/staging/lustre/lustre/obdclass/dt_object.c b/drivers/staging/lustre/lustre/obdclass/dt_object.c
index 4060173..52256c2 100644
--- a/drivers/staging/lustre/lustre/obdclass/dt_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/dt_object.c
@@ -384,26 +384,30 @@ struct dt_object *dt_find_or_create(const struct lu_env *env,
 		return dto;
 
 	th = dt_trans_create(env, dt);
-	if (IS_ERR(th))
-		GOTO(out, rc = PTR_ERR(th));
+	if (IS_ERR(th)) {
+		rc = PTR_ERR(th);
+		goto out;
+	}
 
 	rc = dt_declare_create(env, dto, at, NULL, dof, th);
 	if (rc)
-		GOTO(trans_stop, rc);
+		goto trans_stop;
 
 	rc = dt_trans_start_local(env, dt, th);
 	if (rc)
-		GOTO(trans_stop, rc);
+		goto trans_stop;
 
 	dt_write_lock(env, dto, 0);
-	if (dt_object_exists(dto))
-		GOTO(unlock, rc = 0);
+	if (dt_object_exists(dto)) {
+		rc = 0;
+		goto unlock;
+	}
 
 	CDEBUG(D_OTHER, "create new object "DFID"\n", PFID(fid));
 
 	rc = dt_create(env, dto, at, NULL, dof, th);
 	if (rc)
-		GOTO(unlock, rc);
+		goto unlock;
 	LASSERT(dt_object_exists(dto));
 unlock:
 	dt_write_unlock(env, dto);
@@ -683,8 +687,10 @@ static int dt_index_page_build(const struct lu_env *env, union lu_page *lp,
 		ii->ii_hash_end = hash;
 
 		if (OBD_FAIL_CHECK(OBD_FAIL_OBD_IDX_READ_BREAK)) {
-			if (lip->lip_nr != 0)
-				GOTO(out, rc = 0);
+			if (lip->lip_nr != 0) {
+				rc = 0;
+				goto out;
+			}
 		}
 
 		if (nob < size) {
@@ -712,7 +718,7 @@ static int dt_index_page_build(const struct lu_env *env, union lu_page *lp,
 		rc = iops->rec(env, it, (struct dt_rec *)tmp_entry, attr);
 		if (rc != -ESTALE) {
 			if (rc != 0)
-				GOTO(out, rc);
+				goto out;
 
 			/* hash/key/record successfully copied! */
 			lip->lip_nr++;
@@ -729,7 +735,7 @@ static int dt_index_page_build(const struct lu_env *env, union lu_page *lp,
 
 	} while (rc == 0);
 
-	GOTO(out, rc);
+	goto out;
 out:
 	if (rc >= 0 && lip->lip_nr > 0)
 		/* one more container */
@@ -871,20 +877,24 @@ int dt_index_read(const struct lu_env *env, struct dt_device *dev,
 	obj = dt_locate(env, dev, &ii->ii_fid);
 	if (IS_ERR(obj))
 		return PTR_ERR(obj);
-	if (dt_object_exists(obj) == 0)
-		GOTO(out, rc = -ENOENT);
+	if (dt_object_exists(obj) == 0) {
+		rc = -ENOENT;
+		goto out;
+	}
 
 	/* fetch index features associated with index object */
 	feat = dt_index_feat_select(fid_seq(&ii->ii_fid),
 				    lu_object_attr(&obj->do_lu));
-	if (IS_ERR(feat))
-		GOTO(out, rc = PTR_ERR(feat));
+	if (IS_ERR(feat)) {
+		rc = PTR_ERR(feat);
+		goto out;
+	}
 
 	/* load index feature if not done already */
 	if (obj->do_index_ops == NULL) {
 		rc = obj->do_ops->do_index_try(env, obj, feat);
 		if (rc)
-			GOTO(out, rc);
+			goto out;
 	}
 
 	/* fill ii_flags with supported index features */
@@ -895,7 +905,8 @@ int dt_index_read(const struct lu_env *env, struct dt_device *dev,
 		/* key size is variable */
 		ii->ii_flags |= II_FL_VARKEY;
 		/* we don't support variable key size for the time being */
-		GOTO(out, rc = -EOPNOTSUPP);
+		rc = -EOPNOTSUPP;
+		goto out;
 	}
 
 	ii->ii_recsize = feat->dif_recsize_max;
@@ -903,7 +914,8 @@ int dt_index_read(const struct lu_env *env, struct dt_device *dev,
 		/* record size is variable */
 		ii->ii_flags |= II_FL_VARREC;
 		/* we don't support variable record size for the time being */
-		GOTO(out, rc = -EOPNOTSUPP);
+		rc = -EOPNOTSUPP;
+		goto out;
 	}
 
 	if ((feat->dif_flags & DT_IND_NONUNQ) != 0)
@@ -924,7 +936,7 @@ int dt_index_read(const struct lu_env *env, struct dt_device *dev,
 		ii->ii_hash_end = II_END_OFF;
 	}
 
-	GOTO(out, rc);
+	goto out;
 out:
 	lu_object_put(env, &obj->do_lu);
 	return rc;
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index c2e561d..49df291 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -184,7 +184,7 @@ int class_register_type(struct obd_ops *dt_ops, struct md_ops *md_ops,
 	if (type->typ_dt_ops == NULL ||
 	    type->typ_md_ops == NULL ||
 	    type->typ_name == NULL)
-		GOTO (failed, rc);
+		goto failed;
 
 	*(type->typ_dt_ops) = *dt_ops;
 	/* md_ops is optional */
@@ -198,14 +198,14 @@ int class_register_type(struct obd_ops *dt_ops, struct md_ops *md_ops,
 	if (IS_ERR(type->typ_procroot)) {
 		rc = PTR_ERR(type->typ_procroot);
 		type->typ_procroot = NULL;
-		GOTO (failed, rc);
+		goto failed;
 	}
 
 	if (ldt != NULL) {
 		type->typ_lu = ldt;
 		rc = lu_device_type_init(ldt);
 		if (rc != 0)
-			GOTO (failed, rc);
+			goto failed;
 	}
 
 	spin_lock(&obd_types_lock);
@@ -295,8 +295,10 @@ struct obd_device *class_newdev(const char *type_name, const char *name)
 	}
 
 	newdev = obd_device_alloc();
-	if (newdev == NULL)
-		GOTO(out_type, result = ERR_PTR(-ENOMEM));
+	if (newdev == NULL) {
+		result = ERR_PTR(-ENOMEM);
+		goto out_type;
+	}
 
 	LASSERT(newdev->obd_magic == OBD_DEVICE_MAGIC);
 
@@ -336,11 +338,12 @@ struct obd_device *class_newdev(const char *type_name, const char *name)
 	if (result == NULL && i >= class_devno_max()) {
 		CERROR("all %u OBD devices used, increase MAX_OBD_DEVICES\n",
 		       class_devno_max());
-		GOTO(out, result = ERR_PTR(-EOVERFLOW));
+		result = ERR_PTR(-EOVERFLOW);
+		goto out;
 	}
 
 	if (IS_ERR(result))
-		GOTO(out, result);
+		goto out;
 
 	CDEBUG(D_IOCTL, "Adding new device %s (%p)\n",
 	       result->obd_name, result);
@@ -656,26 +659,26 @@ int obd_init_caches(void)
 						 sizeof(struct obd_device),
 						 0, 0, NULL);
 	if (!obd_device_cachep)
-		GOTO(out, -ENOMEM);
+		goto out;
 
 	LASSERT(obdo_cachep == NULL);
 	obdo_cachep = kmem_cache_create("ll_obdo_cache", sizeof(struct obdo),
 					   0, 0, NULL);
 	if (!obdo_cachep)
-		GOTO(out, -ENOMEM);
+		goto out;
 
 	LASSERT(import_cachep == NULL);
 	import_cachep = kmem_cache_create("ll_import_cache",
 					     sizeof(struct obd_import),
 					     0, 0, NULL);
 	if (!import_cachep)
-		GOTO(out, -ENOMEM);
+		goto out;
 
 	LASSERT(capa_cachep == NULL);
 	capa_cachep = kmem_cache_create("capa_cache",
 					   sizeof(struct obd_capa), 0, 0, NULL);
 	if (!capa_cachep)
-		GOTO(out, -ENOMEM);
+		goto out;
 
 	return 0;
  out:
@@ -857,12 +860,16 @@ struct obd_export *class_new_export(struct obd_device *obd,
 
 	spin_lock(&obd->obd_dev_lock);
 	/* shouldn't happen, but might race */
-	if (obd->obd_stopping)
-		GOTO(exit_unlock, rc = -ENODEV);
+	if (obd->obd_stopping) {
+		rc = -ENODEV;
+		goto exit_unlock;
+	}
 
 	hash = cfs_hash_getref(obd->obd_uuid_hash);
-	if (hash == NULL)
-		GOTO(exit_unlock, rc = -ENODEV);
+	if (hash == NULL) {
+		rc = -ENODEV;
+		goto exit_unlock;
+	}
 	spin_unlock(&obd->obd_dev_lock);
 
 	if (!obd_uuid_equals(cluuid, &obd->obd_uuid)) {
@@ -870,14 +877,16 @@ struct obd_export *class_new_export(struct obd_device *obd,
 		if (rc != 0) {
 			LCONSOLE_WARN("%s: denying duplicate export for %s, %d\n",
 				      obd->obd_name, cluuid->uuid, rc);
-			GOTO(exit_err, rc = -EALREADY);
+			rc = -EALREADY;
+			goto exit_err;
 		}
 	}
 
 	spin_lock(&obd->obd_dev_lock);
 	if (obd->obd_stopping) {
 		cfs_hash_del(hash, cluuid, &export->exp_uuid_hash);
-		GOTO(exit_unlock, rc = -ENODEV);
+		rc = -ENODEV;
+		goto exit_unlock;
 	}
 
 	class_incref(obd, "export", export);
@@ -1187,7 +1196,7 @@ int class_disconnect(struct obd_export *export)
 	 * call extra class_export_puts(). */
 	if (already_disconnected) {
 		LASSERT(hlist_unhashed(&export->exp_nid_hash));
-		GOTO(no_disconn, already_disconnected);
+		goto no_disconn;
 	}
 
 	CDEBUG(D_IOCTL, "disconnect: cookie %#llx\n",
diff --git a/drivers/staging/lustre/lustre/obdclass/llog.c b/drivers/staging/lustre/lustre/obdclass/llog.c
index 1cf604d..3ab0529 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog.c
@@ -140,7 +140,7 @@ int llog_cancel_rec(const struct lu_env *env, struct llog_handle *loghandle,
 			       loghandle->lgh_ctxt->loc_obd->obd_name,
 			       POSTID(&loghandle->lgh_id.lgl_oi),
 			       loghandle->lgh_id.lgl_ogen, rc);
-			GOTO(out_err, rc);
+			goto out_err;
 		}
 		return 1;
 	}
@@ -153,7 +153,7 @@ int llog_cancel_rec(const struct lu_env *env, struct llog_handle *loghandle,
 		       loghandle->lgh_ctxt->loc_obd->obd_name,
 		       POSTID(&loghandle->lgh_id.lgl_oi),
 		       loghandle->lgh_id.lgl_ogen, rc);
-		GOTO(out_err, rc);
+		goto out_err;
 	}
 	return 0;
 out_err:
@@ -224,7 +224,8 @@ int llog_init_handle(const struct lu_env *env, struct llog_handle *handle,
 			       llh->llh_flags & LLOG_F_IS_CAT ?
 			       "catalog" : "plain",
 			       flags & LLOG_F_IS_CAT ? "catalog" : "plain");
-			GOTO(out, rc = -EINVAL);
+			rc = -EINVAL;
+			goto out;
 		} else if (llh->llh_flags &
 			   (LLOG_F_IS_PLAIN | LLOG_F_IS_CAT)) {
 			/*
@@ -235,7 +236,8 @@ int llog_init_handle(const struct lu_env *env, struct llog_handle *handle,
 		} else {
 			/* for some reason the llh_flags has no type set */
 			CERROR("llog type is not specified!\n");
-			GOTO(out, rc = -EINVAL);
+			rc = -EINVAL;
+			goto out;
 		}
 		if (unlikely(uuid &&
 			     !obd_uuid_equals(uuid, &llh->llh_tgtuuid))) {
@@ -243,7 +245,8 @@ int llog_init_handle(const struct lu_env *env, struct llog_handle *handle,
 			       handle->lgh_ctxt->loc_obd->obd_name,
 			       (char *)uuid->uuid,
 			       (char *)llh->llh_tgtuuid.uuid);
-			GOTO(out, rc = -EEXIST);
+			rc = -EEXIST;
+			goto out;
 		}
 	}
 	if (flags & LLOG_F_IS_CAT) {
@@ -316,7 +319,7 @@ repeat:
 		rc = llog_next_block(lpi->lpi_env, loghandle, &saved_index,
 				     index, &cur_offset, buf, LLOG_CHUNK_SIZE);
 		if (rc)
-			GOTO(out, rc);
+			goto out;
 
 		/* NB: when rec->lrh_len is accessed it is already swabbed
 		 * since it is used at the "end" of the loop and the rec
@@ -346,7 +349,8 @@ repeat:
 				CWARN("invalid length %d in llog record for "
 				      "index %d/%d\n", rec->lrh_len,
 				      rec->lrh_index, index);
-				GOTO(out, rc = -EINVAL);
+				rc = -EINVAL;
+				goto out;
 			}
 
 			if (rec->lrh_index < index) {
@@ -370,7 +374,7 @@ repeat:
 						 lpi->lpi_cbdata);
 				last_called_index = index;
 				if (rc == LLOG_PROC_BREAK) {
-					GOTO(out, rc);
+					goto out;
 				} else if (rc == LLOG_DEL_RECORD) {
 					llog_cancel_rec(lpi->lpi_env,
 							loghandle,
@@ -378,15 +382,17 @@ repeat:
 					rc = 0;
 				}
 				if (rc)
-					GOTO(out, rc);
+					goto out;
 			} else {
 				CDEBUG(D_OTHER, "Skipped index %d\n", index);
 			}
 
 			/* next record, still in buffer? */
 			++index;
-			if (index > last_index)
-				GOTO(out, rc = 0);
+			if (index > last_index) {
+				rc = 0;
+				goto out;
+			}
 		}
 	}
 
@@ -507,7 +513,7 @@ int llog_reverse_process(const struct lu_env *env,
 		rc = llog_prev_block(env, loghandle, index, buf,
 				     LLOG_CHUNK_SIZE);
 		if (rc)
-			GOTO(out, rc);
+			goto out;
 
 		rec = buf;
 		idx = rec->lrh_index;
@@ -523,8 +529,11 @@ int llog_reverse_process(const struct lu_env *env,
 
 		/* process records in buffer, starting where we found one */
 		while ((void *)tail > buf) {
-			if (tail->lrt_index == 0)
-				GOTO(out, rc = 0); /* no more records */
+			if (tail->lrt_index == 0) {
+				/* no more records */
+				rc = 0;
+				goto out;
+			}
 
 			/* if set, process the callback on this record */
 			if (ext2_test_bit(index, llh->llh_bitmap)) {
@@ -533,20 +542,22 @@ int llog_reverse_process(const struct lu_env *env,
 
 				rc = cb(env, loghandle, rec, data);
 				if (rc == LLOG_PROC_BREAK) {
-					GOTO(out, rc);
+					goto out;
 				} else if (rc == LLOG_DEL_RECORD) {
 					llog_cancel_rec(env, loghandle,
 							tail->lrt_index);
 					rc = 0;
 				}
 				if (rc)
-					GOTO(out, rc);
+					goto out;
 			}
 
 			/* previous record, still in buffer? */
 			--index;
-			if (index < first_index)
-				GOTO(out, rc = 0);
+			if (index < first_index) {
+				rc = 0;
+				goto out;
+			}
 			tail = (void *)tail - tail->lrt_len;
 		}
 	}
@@ -751,8 +762,10 @@ int llog_open_create(const struct lu_env *env, struct llog_ctxt *ctxt,
 	d = lu2dt_dev((*res)->lgh_obj->do_lu.lo_dev);
 
 	th = dt_trans_create(env, d);
-	if (IS_ERR(th))
-		GOTO(out, rc = PTR_ERR(th));
+	if (IS_ERR(th)) {
+		rc = PTR_ERR(th);
+		goto out;
+	}
 
 	rc = llog_declare_create(env, *res, th);
 	if (rc == 0) {
@@ -821,11 +834,11 @@ int llog_write(const struct lu_env *env, struct llog_handle *loghandle,
 
 	rc = llog_declare_write_rec(env, loghandle, rec, idx, th);
 	if (rc)
-		GOTO(out_trans, rc);
+		goto out_trans;
 
 	rc = dt_trans_start_local(env, dt, th);
 	if (rc)
-		GOTO(out_trans, rc);
+		goto out_trans;
 
 	down_write(&loghandle->lgh_lock);
 	rc = llog_write_rec(env, loghandle, rec, reccookie,
@@ -879,9 +892,11 @@ int llog_close(const struct lu_env *env, struct llog_handle *loghandle)
 
 	rc = llog_handle2ops(loghandle, &lop);
 	if (rc)
-		GOTO(out, rc);
-	if (lop->lop_close == NULL)
-		GOTO(out, rc = -EOPNOTSUPP);
+		goto out;
+	if (lop->lop_close == NULL) {
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
 	rc = lop->lop_close(env, loghandle);
 out:
 	llog_handle_put(loghandle);
@@ -899,12 +914,12 @@ int llog_is_empty(const struct lu_env *env, struct llog_ctxt *ctxt,
 	if (rc < 0) {
 		if (likely(rc == -ENOENT))
 			rc = 0;
-		GOTO(out, rc);
+		goto out;
 	}
 
 	rc = llog_init_handle(env, llh, LLOG_F_IS_PLAIN, NULL);
 	if (rc)
-		GOTO(out_close, rc);
+		goto out_close;
 	rc = llog_get_size(llh);
 
 out_close:
@@ -949,19 +964,19 @@ int llog_backup(const struct lu_env *env, struct obd_device *obd,
 
 	rc = llog_init_handle(env, llh, LLOG_F_IS_PLAIN, NULL);
 	if (rc)
-		GOTO(out_close, rc);
+		goto out_close;
 
 	/* Make sure there's no old backup log */
 	rc = llog_erase(env, bctxt, NULL, backup);
 	if (rc < 0 && rc != -ENOENT)
-		GOTO(out_close, rc);
+		goto out_close;
 
 	/* open backup log */
 	rc = llog_open_create(env, bctxt, &bllh, NULL, backup);
 	if (rc) {
 		CERROR("%s: failed to open backup logfile %s: rc = %d\n",
 		       obd->obd_name, backup, rc);
-		GOTO(out_close, rc);
+		goto out_close;
 	}
 
 	/* check that backup llog is not the same object as original one */
@@ -969,12 +984,13 @@ int llog_backup(const struct lu_env *env, struct obd_device *obd,
 		CERROR("%s: backup llog %s to itself (%s), objects %p/%p\n",
 		       obd->obd_name, name, backup, llh->lgh_obj,
 		       bllh->lgh_obj);
-		GOTO(out_backup, rc = -EEXIST);
+		rc = -EEXIST;
+		goto out_backup;
 	}
 
 	rc = llog_init_handle(env, bllh, LLOG_F_IS_PLAIN, NULL);
 	if (rc)
-		GOTO(out_backup, rc);
+		goto out_backup;
 
 	/* Copy log record by record */
 	rc = llog_process_or_fork(env, llh, llog_copy_handler, (void *)bllh,
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_cat.c b/drivers/staging/lustre/lustre/obdclass/llog_cat.c
index a7c75e2..6e139cf 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_cat.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_cat.c
@@ -96,7 +96,7 @@ static int llog_cat_new_log(const struct lu_env *env,
 			      LLOG_F_IS_PLAIN | LLOG_F_ZAP_WHEN_EMPTY,
 			      &cathandle->lgh_hdr->llh_tgtuuid);
 	if (rc)
-		GOTO(out_destroy, rc);
+		goto out_destroy;
 
 	if (index == 0)
 		index = 1;
@@ -131,7 +131,7 @@ static int llog_cat_new_log(const struct lu_env *env,
 	rc = llog_write_rec(env, cathandle, &rec.lid_hdr,
 			    &loghandle->u.phd.phd_cookie, 1, NULL, index, th);
 	if (rc < 0)
-		GOTO(out_destroy, rc);
+		goto out_destroy;
 
 	loghandle->lgh_hdr->llh_cat_idx = index;
 	return 0;
@@ -174,7 +174,8 @@ int llog_cat_id2handle(const struct lu_env *env, struct llog_handle *cathandle,
 			}
 			loghandle->u.phd.phd_cat_handle = cathandle;
 			up_write(&cathandle->lgh_lock);
-			GOTO(out, rc = 0);
+			rc = 0;
+			goto out;
 		}
 	}
 	up_write(&cathandle->lgh_lock);
@@ -404,20 +405,20 @@ int llog_cat_declare_add_rec(const struct lu_env *env,
 		up_write(&cathandle->lgh_lock);
 	}
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	if (!llog_exist(cathandle->u.chd.chd_current_log)) {
 		rc = llog_declare_create(env, cathandle->u.chd.chd_current_log,
 					 th);
 		if (rc)
-			GOTO(out, rc);
+			goto out;
 		llog_declare_write_rec(env, cathandle, NULL, -1, th);
 	}
 	/* declare records in the llogs */
 	rc = llog_declare_write_rec(env, cathandle->u.chd.chd_current_log,
 				    rec, -1, th);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	next = cathandle->u.chd.chd_next_log;
 	if (next) {
@@ -455,11 +456,11 @@ int llog_cat_add(const struct lu_env *env, struct llog_handle *cathandle,
 
 		rc = llog_cat_declare_add_rec(env, cathandle, rec, th);
 		if (rc)
-			GOTO(out_trans, rc);
+			goto out_trans;
 
 		rc = dt_trans_start_local(env, dt, th);
 		if (rc)
-			GOTO(out_trans, rc);
+			goto out_trans;
 		rc = llog_cat_add_rec(env, cathandle, rec, reccookie, buf, th);
 out_trans:
 		dt_trans_stop(env, dt, th);
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_ioctl.c b/drivers/staging/lustre/lustre/obdclass/llog_ioctl.c
index 9b7fa1d..4f3f0ea 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_ioctl.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_ioctl.c
@@ -250,7 +250,7 @@ static int llog_remove_log(const struct lu_env *env, struct llog_handle *cat,
 	rc = llog_destroy(env, log);
 	if (rc) {
 		CDEBUG(D_IOCTL, "cannot destroy log\n");
-		GOTO(out, rc);
+		goto out;
 	}
 	llog_cat_cleanup(env, cat, log, log->u.phd.phd_cookie.lgc_index);
 out:
@@ -300,8 +300,10 @@ int llog_ioctl(const struct lu_env *env, struct llog_ctxt *ctxt, int cmd,
 	}
 
 	rc = llog_init_handle(env, handle, 0, NULL);
-	if (rc)
-		GOTO(out_close, rc = -ENOENT);
+	if (rc) {
+		rc = -ENOENT;
+		goto out_close;
+	}
 
 	switch (cmd) {
 	case OBD_IOC_LLOG_INFO: {
@@ -337,7 +339,7 @@ int llog_ioctl(const struct lu_env *env, struct llog_ctxt *ctxt, int cmd,
 		if (rc == -LLOG_EEMPTY)
 			rc = 0;
 		else if (rc)
-			GOTO(out_close, rc);
+			goto out_close;
 		break;
 	case OBD_IOC_LLOG_PRINT:
 		LASSERT(data->ioc_inllen1 > 0);
@@ -345,7 +347,7 @@ int llog_ioctl(const struct lu_env *env, struct llog_ctxt *ctxt, int cmd,
 		if (rc == -LLOG_EEMPTY)
 			rc = 0;
 		else if (rc)
-			GOTO(out_close, rc);
+			goto out_close;
 		break;
 	case OBD_IOC_LLOG_CANCEL: {
 		struct llog_cookie cookie;
@@ -353,26 +355,31 @@ int llog_ioctl(const struct lu_env *env, struct llog_ctxt *ctxt, int cmd,
 		char *endp;
 
 		cookie.lgc_index = simple_strtoul(data->ioc_inlbuf3, &endp, 0);
-		if (*endp != '\0')
-			GOTO(out_close, rc = -EINVAL);
+		if (*endp != '\0') {
+			rc = -EINVAL;
+			goto out_close;
+		}
 
 		if (handle->lgh_hdr->llh_flags & LLOG_F_IS_PLAIN) {
 			rc = llog_cancel_rec(NULL, handle, cookie.lgc_index);
-			GOTO(out_close, rc);
+			goto out_close;
 		} else if (!(handle->lgh_hdr->llh_flags & LLOG_F_IS_CAT)) {
-			GOTO(out_close, rc = -EINVAL);
+			rc = -EINVAL;
+			goto out_close;
 		}
 
-		if (data->ioc_inlbuf2 == NULL) /* catalog but no logid */
-			GOTO(out_close, rc = -ENOTTY);
+		if (data->ioc_inlbuf2 == NULL) /* catalog but no logid */ {
+			rc = -ENOTTY;
+			goto out_close;
+		}
 
 		rc = str2logid(&plain, data->ioc_inlbuf2, data->ioc_inllen2);
 		if (rc)
-			GOTO(out_close, rc);
+			goto out_close;
 		cookie.lgc_lgl = plain;
 		rc = llog_cat_cancel_records(env, handle, 1, &cookie);
 		if (rc)
-			GOTO(out_close, rc);
+			goto out_close;
 		break;
 	}
 	case OBD_IOC_LLOG_REMOVE: {
@@ -380,9 +387,10 @@ int llog_ioctl(const struct lu_env *env, struct llog_ctxt *ctxt, int cmd,
 
 		if (handle->lgh_hdr->llh_flags & LLOG_F_IS_PLAIN) {
 			rc = llog_destroy(env, handle);
-			GOTO(out_close, rc);
+			goto out_close;
 		} else if (!(handle->lgh_hdr->llh_flags & LLOG_F_IS_CAT)) {
-			GOTO(out_close, rc = -EINVAL);
+			rc = -EINVAL;
+			goto out_close;
 		}
 
 		if (data->ioc_inllen2 > 0) {
@@ -390,21 +398,22 @@ int llog_ioctl(const struct lu_env *env, struct llog_ctxt *ctxt, int cmd,
 			rc = str2logid(&plain, data->ioc_inlbuf2,
 				       data->ioc_inllen2);
 			if (rc)
-				GOTO(out_close, rc);
+				goto out_close;
 			rc = llog_remove_log(env, handle, &plain);
 		} else {
 			/* remove all the log of the catalog */
 			rc = llog_process(env, handle, llog_delete_cb, NULL,
 					  NULL);
 			if (rc)
-				GOTO(out_close, rc);
+				goto out_close;
 		}
 		break;
 	}
 	default:
 		CERROR("%s: Unknown ioctl cmd %#x\n",
 		       ctxt->loc_obd->obd_name, cmd);
-		GOTO(out_close, rc = -ENOTTY);
+		rc = -ENOTTY;
+		goto out_close;
 	}
 
 out_close:
diff --git a/drivers/staging/lustre/lustre/obdclass/local_storage.c b/drivers/staging/lustre/lustre/obdclass/local_storage.c
index 6e0f6f2..773ee3b 100644
--- a/drivers/staging/lustre/lustre/obdclass/local_storage.c
+++ b/drivers/staging/lustre/lustre/obdclass/local_storage.c
@@ -144,12 +144,14 @@ struct ls_device *ls_device_get(struct dt_device *dev)
 	mutex_lock(&ls_list_mutex);
 	ls = __ls_find_dev(dev);
 	if (ls)
-		GOTO(out_ls, ls);
+		goto out_ls;
 
 	/* not found, then create */
 	OBD_ALLOC_PTR(ls);
-	if (ls == NULL)
-		GOTO(out_ls, ls = ERR_PTR(-ENOMEM));
+	if (ls == NULL) {
+		ls = ERR_PTR(-ENOMEM);
+		goto out_ls;
+	}
 
 	atomic_set(&ls->ls_refcount, 1);
 	INIT_LIST_HEAD(&ls->ls_los_list);
@@ -299,16 +301,20 @@ struct dt_object *__local_file_create(const struct lu_env *env,
 		return dto;
 
 	LASSERT(dto != NULL);
-	if (dt_object_exists(dto))
-		GOTO(out, rc = -EEXIST);
+	if (dt_object_exists(dto)) {
+		rc = -EEXIST;
+		goto out;
+	}
 
 	th = dt_trans_create(env, ls->ls_osd);
-	if (IS_ERR(th))
-		GOTO(out, rc = PTR_ERR(th));
+	if (IS_ERR(th)) {
+		rc = PTR_ERR(th);
+		goto out;
+	}
 
 	rc = local_object_declare_create(env, los, dto, attr, dof, th);
 	if (rc)
-		GOTO(trans_stop, rc);
+		goto trans_stop;
 
 	if (dti->dti_dof.dof_type == DFT_DIR) {
 		dt_declare_ref_add(env, dto, th);
@@ -317,36 +323,40 @@ struct dt_object *__local_file_create(const struct lu_env *env,
 
 	rc = dt_declare_insert(env, parent, (void *)fid, (void *)name, th);
 	if (rc)
-		GOTO(trans_stop, rc);
+		goto trans_stop;
 
 	rc = dt_trans_start_local(env, ls->ls_osd, th);
 	if (rc)
-		GOTO(trans_stop, rc);
+		goto trans_stop;
 
 	dt_write_lock(env, dto, 0);
-	if (dt_object_exists(dto))
-		GOTO(unlock, rc = 0);
+	if (dt_object_exists(dto)) {
+		rc = 0;
+		goto unlock;
+	}
 
 	CDEBUG(D_OTHER, "create new object "DFID"\n",
 	       PFID(lu_object_fid(&dto->do_lu)));
 	rc = local_object_create(env, los, dto, attr, dof, th);
 	if (rc)
-		GOTO(unlock, rc);
+		goto unlock;
 	LASSERT(dt_object_exists(dto));
 
 	if (dti->dti_dof.dof_type == DFT_DIR) {
-		if (!dt_try_as_dir(env, dto))
-			GOTO(destroy, rc = -ENOTDIR);
+		if (!dt_try_as_dir(env, dto)) {
+			rc = -ENOTDIR;
+			goto destroy;
+		}
 		/* Add "." and ".." for newly created dir */
 		rc = dt_insert(env, dto, (void *)fid, (void *)".", th,
 			       BYPASS_CAPA, 1);
 		if (rc)
-			GOTO(destroy, rc);
+			goto destroy;
 		dt_ref_add(env, dto, th);
 		rc = dt_insert(env, dto, (void *)lu_object_fid(&parent->do_lu),
 			       (void *)"..", th, BYPASS_CAPA, 1);
 		if (rc)
-			GOTO(destroy, rc);
+			goto destroy;
 	}
 
 	dt_write_lock(env, parent, 0);
@@ -356,7 +366,7 @@ struct dt_object *__local_file_create(const struct lu_env *env,
 		dt_ref_add(env, parent, th);
 	dt_write_unlock(env, parent);
 	if (rc)
-		GOTO(destroy, rc);
+		goto destroy;
 destroy:
 	if (rc)
 		dt_destroy(env, dto, th);
@@ -591,28 +601,30 @@ int local_object_unlink(const struct lu_env *env, struct dt_device *dt,
 		return PTR_ERR(dto);
 
 	th = dt_trans_create(env, dt);
-	if (IS_ERR(th))
-		GOTO(out, rc = PTR_ERR(th));
+	if (IS_ERR(th)) {
+		rc = PTR_ERR(th);
+		goto out;
+	}
 
 	rc = local_object_declare_unlink(env, dt, parent, dto, name, th);
 	if (rc < 0)
-		GOTO(stop, rc);
+		goto stop;
 
 	rc = dt_trans_start_local(env, dt, th);
 	if (rc < 0)
-		GOTO(stop, rc);
+		goto stop;
 
 	dt_write_lock(env, dto, 0);
 	rc = dt_delete(env, parent, (struct dt_key *)name, th, BYPASS_CAPA);
 	if (rc < 0)
-		GOTO(unlock, rc);
+		goto unlock;
 
 	rc = dt_ref_del(env, dto, th);
 	if (rc < 0) {
 		rc = dt_insert(env, parent,
 			       (const struct dt_rec *)&dti->dti_fid,
 			       (const struct dt_key *)name, th, BYPASS_CAPA, 1);
-		GOTO(unlock, rc);
+		goto unlock;
 	}
 
 	rc = dt_destroy(env, dto, th);
@@ -757,13 +769,17 @@ int local_oid_storage_init(const struct lu_env *env, struct dt_device *dev,
 
 	mutex_lock(&ls->ls_los_mutex);
 	*los = dt_los_find(ls, fid_seq(first_fid));
-	if (*los != NULL)
-		GOTO(out, rc = 0);
+	if (*los != NULL) {
+		rc = 0;
+		goto out;
+	}
 
 	/* not found, then create */
 	OBD_ALLOC_PTR(*los);
-	if (*los == NULL)
-		GOTO(out, rc = -ENOMEM);
+	if (*los == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	atomic_set(&(*los)->los_refcount, 1);
 	mutex_init(&(*los)->los_id_lock);
@@ -778,18 +794,22 @@ int local_oid_storage_init(const struct lu_env *env, struct dt_device *dev,
 	dti->dti_fid.f_oid = LUSTRE_FID_LASTID_OID;
 	dti->dti_fid.f_ver = 0;
 	o = ls_locate(env, ls, &dti->dti_fid);
-	if (IS_ERR(o))
-		GOTO(out_los, rc = PTR_ERR(o));
+	if (IS_ERR(o)) {
+		rc = PTR_ERR(o);
+		goto out_los;
+	}
 
 	if (!dt_object_exists(o)) {
 		rc = lastid_compat_check(env, dev, fid_seq(first_fid),
 					 &first_oid, ls);
 		if (rc < 0)
-			GOTO(out_los, rc);
+			goto out_los;
 
 		th = dt_trans_create(env, dev);
-		if (IS_ERR(th))
-			GOTO(out_los, rc = PTR_ERR(th));
+		if (IS_ERR(th)) {
+			rc = PTR_ERR(th);
+			goto out_los;
+		}
 
 		dti->dti_attr.la_valid = LA_MODE | LA_TYPE;
 		dti->dti_attr.la_mode = S_IFREG | S_IRUGO | S_IWUSR;
@@ -798,24 +818,26 @@ int local_oid_storage_init(const struct lu_env *env, struct dt_device *dev,
 		rc = dt_declare_create(env, o, &dti->dti_attr, NULL,
 				       &dti->dti_dof, th);
 		if (rc)
-			GOTO(out_trans, rc);
+			goto out_trans;
 
 		rc = dt_declare_record_write(env, o, sizeof(lastid), 0, th);
 		if (rc)
-			GOTO(out_trans, rc);
+			goto out_trans;
 
 		rc = dt_trans_start_local(env, dev, th);
 		if (rc)
-			GOTO(out_trans, rc);
+			goto out_trans;
 
 		dt_write_lock(env, o, 0);
-		if (dt_object_exists(o))
-			GOTO(out_lock, rc = 0);
+		if (dt_object_exists(o)) {
+			rc = 0;
+			goto out_lock;
+		}
 
 		rc = dt_create(env, o, &dti->dti_attr, NULL, &dti->dti_dof,
 			       th);
 		if (rc)
-			GOTO(out_lock, rc);
+			goto out_lock;
 
 		lastid = cpu_to_le64(first_oid);
 
@@ -824,7 +846,7 @@ int local_oid_storage_init(const struct lu_env *env, struct dt_device *dev,
 		dti->dti_lb.lb_len = sizeof(lastid);
 		rc = dt_record_write(env, o, &dti->dti_lb, &dti->dti_off, th);
 		if (rc)
-			GOTO(out_lock, rc);
+			goto out_lock;
 out_lock:
 		dt_write_unlock(env, o);
 out_trans:
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 7893c2d..40af1b0 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -356,8 +356,10 @@ struct proc_dir_entry *lprocfs_register(const char *name,
 	struct proc_dir_entry *entry;
 
 	entry = proc_mkdir(name, parent);
-	if (entry == NULL)
-		GOTO(out, entry = ERR_PTR(-ENOMEM));
+	if (entry == NULL) {
+		entry = ERR_PTR(-ENOMEM);
+		goto out;
+	}
 
 	if (list != NULL) {
 		int rc = lprocfs_add_vars(entry, list, data);
@@ -1683,12 +1685,15 @@ int lprocfs_exp_setup(struct obd_export *exp, lnet_nid_t *nid, int *newnid)
 	 * entry already has been created */
 	if (old_stat != new_stat) {
 		exp->exp_nid_stats = old_stat;
-		GOTO(destroy_new, rc = -EALREADY);
+		rc = -EALREADY;
+		goto destroy_new;
 	}
 	/* not found - create */
 	OBD_ALLOC(buffer, LNET_NIDSTR_SIZE);
-	if (buffer == NULL)
-		GOTO(destroy_new, rc = -ENOMEM);
+	if (buffer == NULL) {
+		rc = -ENOMEM;
+		goto destroy_new;
+	}
 
 	memcpy(buffer, libcfs_nid2str(*nid), LNET_NIDSTR_SIZE);
 	new_stat->nid_proc = lprocfs_register(buffer,
@@ -1701,7 +1706,7 @@ int lprocfs_exp_setup(struct obd_export *exp, lnet_nid_t *nid, int *newnid)
 		       libcfs_nid2str(*nid));
 		rc = PTR_ERR(new_stat->nid_proc);
 		new_stat->nid_proc = NULL;
-		GOTO(destroy_new_ns, rc);
+		goto destroy_new_ns;
 	}
 
 	entry = lprocfs_add_simple(new_stat->nid_proc, "uuid",
@@ -1709,7 +1714,7 @@ int lprocfs_exp_setup(struct obd_export *exp, lnet_nid_t *nid, int *newnid)
 	if (IS_ERR(entry)) {
 		CWARN("Error adding the NID stats file\n");
 		rc = PTR_ERR(entry);
-		GOTO(destroy_new_ns, rc);
+		goto destroy_new_ns;
 	}
 
 	entry = lprocfs_add_simple(new_stat->nid_proc, "hash",
@@ -1717,7 +1722,7 @@ int lprocfs_exp_setup(struct obd_export *exp, lnet_nid_t *nid, int *newnid)
 	if (IS_ERR(entry)) {
 		CWARN("Error adding the hash file\n");
 		rc = PTR_ERR(entry);
-		GOTO(destroy_new_ns, rc);
+		goto destroy_new_ns;
 	}
 
 	exp->exp_nid_stats = new_stat;
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
index 8a9752f..f741b07 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
@@ -365,7 +365,7 @@ int class_attach(struct lustre_cfg *lcfg)
 		obd = NULL;
 		CERROR("Cannot create device %s of type %s : %d\n",
 		       name, typename, rc);
-		GOTO(out, rc);
+		goto out;
 	}
 	LASSERTF(obd != NULL, "Cannot get obd device %s of type %s\n",
 		 name, typename);
@@ -412,15 +412,18 @@ int class_attach(struct lustre_cfg *lcfg)
 	if (len >= sizeof(obd->obd_uuid)) {
 		CERROR("uuid must be < %d bytes long\n",
 		       (int)sizeof(obd->obd_uuid));
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}
 	memcpy(obd->obd_uuid.uuid, uuid, len);
 
 	/* do the attach */
 	if (OBP(obd, attach)) {
 		rc = OBP(obd, attach)(obd, sizeof(*lcfg), lcfg);
-		if (rc)
-			GOTO(out, rc = -EINVAL);
+		if (rc) {
+			rc = -EINVAL;
+			goto out;
+		}
 	}
 
 	/* Detach drops this */
@@ -494,8 +497,10 @@ int class_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 					     CFS_HASH_MIN_THETA,
 					     CFS_HASH_MAX_THETA,
 					     &uuid_hash_ops, CFS_HASH_DEFAULT);
-	if (!obd->obd_uuid_hash)
-		GOTO(err_hash, err = -ENOMEM);
+	if (!obd->obd_uuid_hash) {
+		err = -ENOMEM;
+		goto err_hash;
+	}
 
 	/* create a nid-export lustre hash */
 	obd->obd_nid_hash = cfs_hash_create("NID_HASH",
@@ -505,8 +510,10 @@ int class_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 					    CFS_HASH_MIN_THETA,
 					    CFS_HASH_MAX_THETA,
 					    &nid_hash_ops, CFS_HASH_DEFAULT);
-	if (!obd->obd_nid_hash)
-		GOTO(err_hash, err = -ENOMEM);
+	if (!obd->obd_nid_hash) {
+		err = -ENOMEM;
+		goto err_hash;
+	}
 
 	/* create a nid-stats lustre hash */
 	obd->obd_nid_stats_hash = cfs_hash_create("NID_STATS",
@@ -516,12 +523,16 @@ int class_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 						  CFS_HASH_MIN_THETA,
 						  CFS_HASH_MAX_THETA,
 						  &nid_stat_hash_ops, CFS_HASH_DEFAULT);
-	if (!obd->obd_nid_stats_hash)
-		GOTO(err_hash, err = -ENOMEM);
+	if (!obd->obd_nid_stats_hash) {
+		err = -ENOMEM;
+		goto err_hash;
+	}
 
 	exp = class_new_export(obd, &obd->obd_uuid);
-	if (IS_ERR(exp))
-		GOTO(err_hash, err = PTR_ERR(exp));
+	if (IS_ERR(exp)) {
+		err = PTR_ERR(exp);
+		goto err_hash;
+	}
 
 	obd->obd_self_export = exp;
 	list_del_init(&exp->exp_obd_chain_timed);
@@ -529,7 +540,7 @@ int class_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 
 	err = obd_setup(obd, lcfg);
 	if (err)
-		GOTO(err_exp, err);
+		goto err_exp;
 
 	obd->obd_set_up = 1;
 
@@ -856,21 +867,27 @@ int class_add_profile(int proflen, char *prof, int osclen, char *osc,
 
 	LASSERT(proflen == (strlen(prof) + 1));
 	OBD_ALLOC(lprof->lp_profile, proflen);
-	if (lprof->lp_profile == NULL)
-		GOTO(out, err = -ENOMEM);
+	if (lprof->lp_profile == NULL) {
+		err = -ENOMEM;
+		goto out;
+	}
 	memcpy(lprof->lp_profile, prof, proflen);
 
 	LASSERT(osclen == (strlen(osc) + 1));
 	OBD_ALLOC(lprof->lp_dt, osclen);
-	if (lprof->lp_dt == NULL)
-		GOTO(out, err = -ENOMEM);
+	if (lprof->lp_dt == NULL) {
+		err = -ENOMEM;
+		goto out;
+	}
 	memcpy(lprof->lp_dt, osc, osclen);
 
 	if (mdclen > 0) {
 		LASSERT(mdclen == (strlen(mdc) + 1));
 		OBD_ALLOC(lprof->lp_md, mdclen);
-		if (lprof->lp_md == NULL)
-			GOTO(out, err = -ENOMEM);
+		if (lprof->lp_md == NULL) {
+			err = -ENOMEM;
+			goto out;
+		}
 		memcpy(lprof->lp_md, mdc, mdclen);
 	}
 
@@ -1090,7 +1107,7 @@ int class_process_config(struct lustre_cfg *lcfg)
 	switch (lcfg->lcfg_command) {
 	case LCFG_ATTACH: {
 		err = class_attach(lcfg);
-		GOTO(out, err);
+		goto out;
 	}
 	case LCFG_ADD_UUID: {
 		CDEBUG(D_IOCTL, "adding mapping from uuid %s to nid %#llx (%s)\n",
@@ -1098,7 +1115,7 @@ int class_process_config(struct lustre_cfg *lcfg)
 		       libcfs_nid2str(lcfg->lcfg_nid));
 
 		err = class_add_uuid(lustre_cfg_string(lcfg, 1), lcfg->lcfg_nid);
-		GOTO(out, err);
+		goto out;
 	}
 	case LCFG_DEL_UUID: {
 		CDEBUG(D_IOCTL, "removing mappings for uuid %s\n",
@@ -1106,7 +1123,7 @@ int class_process_config(struct lustre_cfg *lcfg)
 		       ? "<all uuids>" : lustre_cfg_string(lcfg, 1));
 
 		err = class_del_uuid(lustre_cfg_string(lcfg, 1));
-		GOTO(out, err);
+		goto out;
 	}
 	case LCFG_MOUNTOPT: {
 		CDEBUG(D_IOCTL, "mountopt: profile %s osc %s mdc %s\n",
@@ -1121,20 +1138,22 @@ int class_process_config(struct lustre_cfg *lcfg)
 					lustre_cfg_string(lcfg, 2),
 					LUSTRE_CFG_BUFLEN(lcfg, 3),
 					lustre_cfg_string(lcfg, 3));
-		GOTO(out, err);
+		goto out;
 	}
 	case LCFG_DEL_MOUNTOPT: {
 		CDEBUG(D_IOCTL, "mountopt: profile %s\n",
 		       lustre_cfg_string(lcfg, 1));
 		class_del_profile(lustre_cfg_string(lcfg, 1));
-		GOTO(out, err = 0);
+		err = 0;
+		goto out;
 	}
 	case LCFG_SET_TIMEOUT: {
 		CDEBUG(D_IOCTL, "changing lustre timeout from %d to %d\n",
 		       obd_timeout, lcfg->lcfg_num);
 		obd_timeout = max(lcfg->lcfg_num, 1U);
 		obd_timeout_set = 1;
-		GOTO(out, err = 0);
+		err = 0;
+		goto out;
 	}
 	case LCFG_SET_LDLM_TIMEOUT: {
 		CDEBUG(D_IOCTL, "changing lustre ldlm_timeout from %d to %d\n",
@@ -1143,19 +1162,22 @@ int class_process_config(struct lustre_cfg *lcfg)
 		if (ldlm_timeout >= obd_timeout)
 			ldlm_timeout = max(obd_timeout / 3, 1U);
 		ldlm_timeout_set = 1;
-		GOTO(out, err = 0);
+		err = 0;
+		goto out;
 	}
 	case LCFG_SET_UPCALL: {
 		LCONSOLE_ERROR_MSG(0x15a, "recovery upcall is deprecated\n");
 		/* COMPAT_146 Don't fail on old configs */
-		GOTO(out, err = 0);
+		err = 0;
+		goto out;
 	}
 	case LCFG_MARKER: {
 		struct cfg_marker *marker;
 		marker = lustre_cfg_buf(lcfg, 1);
 		CDEBUG(D_IOCTL, "marker %d (%#x) %.16s %s\n", marker->cm_step,
 		       marker->cm_flags, marker->cm_tgtname, marker->cm_comment);
-		GOTO(out, err = 0);
+		err = 0;
+		goto out;
 	}
 	case LCFG_PARAM: {
 		char *tmp;
@@ -1164,7 +1186,7 @@ int class_process_config(struct lustre_cfg *lcfg)
 				       PARAM_LLITE, NULL) == 0) &&
 		    client_process_config) {
 			err = (*client_process_config)(lcfg);
-			GOTO(out, err);
+			goto out;
 		} else if ((class_match_param(lustre_cfg_string(lcfg, 1),
 					      PARAM_SYS, &tmp) == 0)) {
 			/* Global param settings */
@@ -1176,19 +1198,20 @@ int class_process_config(struct lustre_cfg *lcfg)
 			if (err != 0)
 				CWARN("Ignoring unknown param %s\n", tmp);
 
-			GOTO(out, err = 0);
+			err = 0;
+			goto out;
 		} else if ((class_match_param(lustre_cfg_string(lcfg, 1),
 					      PARAM_QUOTA, &tmp) == 0) &&
 			   quota_process_config) {
 			err = (*quota_process_config)(lcfg);
-			GOTO(out, err);
+			goto out;
 		}
 
 		break;
 	}
 	case LCFG_SET_PARAM: {
 		err = process_param2_config(lcfg);
-		GOTO(out, 0);
+		goto out;
 	}
 	}
 	/* Commands that require a device */
@@ -1200,29 +1223,34 @@ int class_process_config(struct lustre_cfg *lcfg)
 			CERROR("no device for: %s\n",
 			       lustre_cfg_string(lcfg, 0));
 
-		GOTO(out, err = -EINVAL);
+		err = -EINVAL;
+		goto out;
 	}
 
 	switch (lcfg->lcfg_command) {
 	case LCFG_SETUP: {
 		err = class_setup(obd, lcfg);
-		GOTO(out, err);
+		goto out;
 	}
 	case LCFG_DETACH: {
 		err = class_detach(obd, lcfg);
-		GOTO(out, err = 0);
+		err = 0;
+		goto out;
 	}
 	case LCFG_CLEANUP: {
 		err = class_cleanup(obd, lcfg);
-		GOTO(out, err = 0);
+		err = 0;
+		goto out;
 	}
 	case LCFG_ADD_CONN: {
 		err = class_add_conn(obd, lcfg);
-		GOTO(out, err = 0);
+		err = 0;
+		goto out;
 	}
 	case LCFG_DEL_CONN: {
 		err = class_del_conn(obd, lcfg);
-		GOTO(out, err = 0);
+		err = 0;
+		goto out;
 	}
 	case LCFG_POOL_NEW: {
 		err = obd_pool_new(obd, lustre_cfg_string(lcfg, 2));
@@ -1248,7 +1276,7 @@ int class_process_config(struct lustre_cfg *lcfg)
 	}
 	default: {
 		err = obd_process_config(obd, sizeof(*lcfg), lcfg);
-		GOTO(out, err);
+		goto out;
 
 	}
 	}
@@ -1382,7 +1410,7 @@ int class_config_llog_handler(const struct lu_env *env,
 
 		rc = lustre_cfg_sanity_check(cfg_buf, cfg_len);
 		if (rc)
-			GOTO(out, rc);
+			goto out;
 
 		/* Figure out config state info */
 		if (lcfg->lcfg_command == LCFG_MARKER) {
@@ -1469,8 +1497,10 @@ int class_config_llog_handler(const struct lu_env *env,
 			inst_len = LUSTRE_CFG_BUFLEN(lcfg, 0) +
 				   sizeof(clli->cfg_instance) * 2 + 4;
 			OBD_ALLOC(inst_name, inst_len);
-			if (inst_name == NULL)
-				GOTO(out, rc = -ENOMEM);
+			if (inst_name == NULL) {
+				rc = -ENOMEM;
+				goto out;
+			}
 			sprintf(inst_name, "%s-%p",
 				lustre_cfg_string(lcfg, 0),
 				clli->cfg_instance);
@@ -1562,7 +1592,7 @@ int class_config_parse_llog(const struct lu_env *env, struct llog_ctxt *ctxt,
 
 	rc = llog_init_handle(env, llh, LLOG_F_IS_PLAIN, NULL);
 	if (rc)
-		GOTO(parse_out, rc);
+		goto parse_out;
 
 	/* continue processing from where we last stopped to end-of-log */
 	if (cfg) {
@@ -1674,7 +1704,7 @@ int class_config_dump_llog(const struct lu_env *env, struct llog_ctxt *ctxt,
 
 	rc = llog_init_handle(env, llh, LLOG_F_IS_PLAIN, NULL);
 	if (rc)
-		GOTO(parse_out, rc);
+		goto parse_out;
 
 	rc = llog_process(env, llh, class_config_dump_handler, cfg, NULL);
 parse_out:
@@ -1717,7 +1747,7 @@ int class_manual_cleanup(struct obd_device *obd)
 	rc = class_process_config(lcfg);
 	if (rc) {
 		CERROR("cleanup failed %d: %s\n", rc, obd->obd_name);
-		GOTO(out, rc);
+		goto out;
 	}
 
 	/* the lcfg is almost the same for both ops */
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index 326a8c4..4e0635d 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -256,15 +256,19 @@ int lustre_start_mgc(struct super_block *sb)
 	len = strlen(LUSTRE_MGC_OBDNAME) + strlen(libcfs_nid2str(nid)) + 1;
 	OBD_ALLOC(mgcname, len);
 	OBD_ALLOC(niduuid, len + 2);
-	if (!mgcname || !niduuid)
-		GOTO(out_free, rc = -ENOMEM);
+	if (!mgcname || !niduuid) {
+		rc = -ENOMEM;
+		goto out_free;
+	}
 	sprintf(mgcname, "%s%s", LUSTRE_MGC_OBDNAME, libcfs_nid2str(nid));
 
 	mgssec = lsi->lsi_lmd->lmd_mgssec ? lsi->lsi_lmd->lmd_mgssec : "";
 
 	OBD_ALLOC_PTR(data);
-	if (data == NULL)
-		GOTO(out_free, rc = -ENOMEM);
+	if (data == NULL) {
+		rc = -ENOMEM;
+		goto out_free;
+	}
 
 	obd = class_name2obd(mgcname);
 	if (obd && !obd->obd_stopping) {
@@ -274,7 +278,7 @@ int lustre_start_mgc(struct super_block *sb)
 					strlen(KEY_MGSSEC), KEY_MGSSEC,
 					strlen(mgssec), mgssec, NULL);
 		if (rc)
-			GOTO(out_free, rc);
+			goto out_free;
 
 		/* Re-using an existing MGC */
 		atomic_inc(&obd->u.cli.cl_mgc_refcount);
@@ -324,7 +328,8 @@ int lustre_start_mgc(struct super_block *sb)
 					sizeof(KEY_INIT_RECOV_BACKUP),
 					KEY_INIT_RECOV_BACKUP,
 					sizeof(recov_bk), &recov_bk, NULL);
-		GOTO(out, rc = 0);
+		rc = 0;
+		goto out;
 	}
 
 	CDEBUG(D_MOUNT, "Start MGC '%s'\n", mgcname);
@@ -350,7 +355,8 @@ int lustre_start_mgc(struct super_block *sb)
 			} else if (class_find_param(ptr, PARAM_MGSNODE,
 						    &ptr) != 0) {
 				CERROR("No MGS nids given.\n");
-				GOTO(out_free, rc = -EINVAL);
+				rc = -EINVAL;
+				goto out_free;
 			}
 			while (class_parse_nid(ptr, &nid, &ptr) == 0) {
 				rc = do_lcfg(mgcname, nid,
@@ -373,7 +379,8 @@ int lustre_start_mgc(struct super_block *sb)
 	}
 	if (i == 0) {
 		CERROR("No valid MGS nids found.\n");
-		GOTO(out_free, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out_free;
 	}
 	lsi->lsi_lmd->lmd_mgs_failnodes = 1;
 
@@ -388,7 +395,7 @@ int lustre_start_mgc(struct super_block *sb)
 				 niduuid, NULL, NULL);
 	OBD_FREE_PTR(uuid);
 	if (rc)
-		GOTO(out_free, rc);
+		goto out_free;
 
 	/* Add any failover MGS nids */
 	i = 1;
@@ -418,14 +425,15 @@ int lustre_start_mgc(struct super_block *sb)
 	obd = class_name2obd(mgcname);
 	if (!obd) {
 		CERROR("Can't find mgcobd %s\n", mgcname);
-		GOTO(out_free, rc = -ENOTCONN);
+		rc = -ENOTCONN;
+		goto out_free;
 	}
 
 	rc = obd_set_info_async(NULL, obd->obd_self_export,
 				strlen(KEY_MGSSEC), KEY_MGSSEC,
 				strlen(mgssec), mgssec, NULL);
 	if (rc)
-		GOTO(out_free, rc);
+		goto out_free;
 
 	/* Keep a refcount of servers/clients who started with "mount",
 	   so we know when we can get rid of the mgc. */
@@ -449,7 +457,7 @@ int lustre_start_mgc(struct super_block *sb)
 	rc = obd_connect(NULL, &exp, obd, &(obd->obd_uuid), data, NULL);
 	if (rc) {
 		CERROR("connect failed %d\n", rc);
-		GOTO(out, rc);
+		goto out;
 	}
 
 	obd->u.cli.cl_mgc_mgsexp = exp;
@@ -491,7 +499,8 @@ static int lustre_stop_mgc(struct super_block *sb)
 		   will call in here. */
 		CDEBUG(D_MOUNT, "mgc still has %d references.\n",
 		       atomic_read(&obd->u.cli.cl_mgc_refcount));
-		GOTO(out, rc = -EBUSY);
+		rc = -EBUSY;
+		goto out;
 	}
 
 	/* The MGC has no recoverable data in any case.
@@ -517,11 +526,13 @@ static int lustre_stop_mgc(struct super_block *sb)
 
 	rc = class_manual_cleanup(obd);
 	if (rc)
-		GOTO(out, rc);
+		goto out;
 
 	/* Clean the nid uuids */
-	if (!niduuid)
-		GOTO(out, rc = -ENOMEM);
+	if (!niduuid) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	for (i = 0; i < lsi->lsi_lmd->lmd_mgs_failnodes; i++) {
 		sprintf(ptr, "_%x", i);
@@ -1212,7 +1223,8 @@ int lustre_fill_super(struct super_block *sb, void *data, int silent)
 	/* Figure out the lmd from the mount options */
 	if (lmd_parse((char *)(lmd2->lmd2_data), lmd)) {
 		lustre_put_lsi(sb);
-		GOTO(out, rc = -EINVAL);
+		rc = -EINVAL;
+		goto out;
 	}
 
 	if (lmd_is_client(lmd)) {
@@ -1229,7 +1241,7 @@ int lustre_fill_super(struct super_block *sb, void *data, int silent)
 			rc = lustre_start_mgc(sb);
 			if (rc) {
 				lustre_put_lsi(sb);
-				GOTO(out, rc);
+				goto out;
 			}
 			/* Connect and start */
 			/* (should always be ll_fill_super) */
@@ -1244,7 +1256,7 @@ int lustre_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* If error happens in fill_super() call, @lsi will be killed there.
 	 * This is why we do not put it here. */
-	GOTO(out, rc);
+	goto out;
 out:
 	if (rc) {
 		CERROR("Unable to mount %s (%d)\n",

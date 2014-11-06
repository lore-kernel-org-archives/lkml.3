Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaKFD06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:26:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57029 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbaKFD0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:26:55 -0500
Message-ID: <1415244407.3398.48.camel@decadent.org.uk>
Subject: [PATCH 2/3] i2o: Define i2o_cfg_passthru() and i2o_cfg_passthru32()
 consistently
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 06 Nov 2014 03:26:47 +0000
In-Reply-To: <1415244281.3398.46.camel@decadent.org.uk>
References: <1415244281.3398.46.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-842rytcx2cX0Td7FPKZp"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-842rytcx2cX0Td7FPKZp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

These functions are dealing with the same message structure regardless
of the native word size, though there are some apparently arbitrary
differences between them.  i2o_cfg_passthru32() looks slightly more
reasonable and has the necessary casts to make the compiler shut up
about 32-bit virtual addresses, so turn it into a common function that
is called in both compat and native cases.

Make all the function definitions conditional on
CONFIG_I2O_EXT_ADAPTEC.

Differences between the two original functions:
- i2o_cfg_passthru() used osm_warn() rather than osm_debug() to
  log failure of i2o_find_iop()
- i2o_cfg_passthru() did not log failure of get_user(size, ...)
  or copy_from_user(msg, ...)
- i2o_cfg_passthru() did not call i2o_dump_message()
- i2o_cfg_passthru() return -EFAULT rather than -EINVAL if the
  request size was out-of-range after the second reading

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/message/i2o/i2o_config.c | 273 ++++++-----------------------------=
----
 1 file changed, 39 insertions(+), 234 deletions(-)

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_con=
fig.c
index 274235d..f9a10a8 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -521,13 +521,10 @@ static int i2o_cfg_evt_get(unsigned long arg, struct =
file *fp)
 	return 0;
 }
=20
-#ifdef CONFIG_COMPAT
-static int i2o_cfg_passthru32(struct file *file, unsigned cmnd,
-			      unsigned long arg)
+#ifdef CONFIG_I2O_EXT_ADAPTEC
+static int __i2o_cfg_passthru(unsigned int iop, u32 __user *user_msg)
 {
-	struct i2o_cmd_passthru32 __user *cmd;
 	struct i2o_controller *c;
-	u32 __user *user_msg;
 	u32 *reply =3D NULL;
 	u32 __user *user_reply =3D NULL;
 	u32 size =3D 0;
@@ -540,14 +537,6 @@ static int i2o_cfg_passthru32(struct file *file, unsig=
ned cmnd,
 	u32 sg_index =3D 0;
 	i2o_status_block *sb;
 	struct i2o_message *msg;
-	unsigned int iop;
-
-	cmd =3D (struct i2o_cmd_passthru32 __user *)arg;
-
-	if (get_user(iop, &cmd->iop) || get_user(i, &cmd->msg))
-		return -EFAULT;
-
-	user_msg =3D compat_ptr(i);
=20
 	c =3D i2o_find_iop(iop);
 	if (!c) {
@@ -710,7 +699,7 @@ static int i2o_cfg_passthru32(struct file *file, unsign=
ed cmnd,
 				sg_size =3D sg[j].flag_count & 0xffffff;
 				// TODO 64bit fix
 				if (copy_to_user
-				    ((void __user *)(u64) sg[j].addr_bus,
+				    ((void __user *)(unsigned long)sg[j].addr_bus,
 				     sg_list[j].virt, sg_size)) {
 					printk(KERN_WARNING
 					       "%s: Could not copy %p TO user %x\n",
@@ -750,6 +739,40 @@ out:
 	return rcode;
 }
=20
+#ifdef CONFIG_COMPAT
+static int i2o_cfg_passthru32(struct file *file, unsigned cmnd,
+			      unsigned long arg)
+{
+	struct i2o_cmd_passthru32 __user *cmd;
+	unsigned int iop;
+	u32 i;
+
+	cmd =3D (struct i2o_cmd_passthru32 __user *)arg;
+
+	if (get_user(iop, &cmd->iop) || get_user(i, &cmd->msg))
+		return -EFAULT;
+
+	return __i2o_cfg_passthru(iop, compat_ptr(i));
+}
+#endif
+
+static int i2o_cfg_passthru(unsigned long arg)
+{
+	struct i2o_cmd_passthru __user *cmd;
+	unsigned int iop;
+	u32 __user *user_msg;
+
+	cmd =3D (struct i2o_cmd_passthru __user *)arg;
+
+	if (get_user(iop, &cmd->iop) || get_user(user_msg, &cmd->msg))
+		return -EFAULT;
+
+	return __i2o_cfg_passthru(iop, user_msg);
+}
+
+#endif /* CONFIG_I2O_EXT_ADAPTEC */
+
+#ifdef CONFIG_COMPAT
 static long i2o_cfg_compat_ioctl(struct file *file, unsigned cmd,
 				 unsigned long arg)
 {
@@ -758,11 +781,13 @@ static long i2o_cfg_compat_ioctl(struct file *file, u=
nsigned cmd,
 	case I2OGETIOPS:
 		ret =3D i2o_cfg_ioctl(file, cmd, arg);
 		break;
+#ifdef CONFIG_I2O_EXT_ADAPTEC
 	case I2OPASSTHRU32:
 		mutex_lock(&i2o_cfg_mutex);
 		ret =3D i2o_cfg_passthru32(file, cmd, arg);
 		mutex_unlock(&i2o_cfg_mutex);
 		break;
+#endif
 	default:
 		ret =3D -ENOIOCTLCMD;
 		break;
@@ -772,226 +797,6 @@ static long i2o_cfg_compat_ioctl(struct file *file, u=
nsigned cmd,
=20
 #endif
=20
-#ifdef CONFIG_I2O_EXT_ADAPTEC
-static int i2o_cfg_passthru(unsigned long arg)
-{
-	struct i2o_cmd_passthru __user *cmd =3D
-	    (struct i2o_cmd_passthru __user *)arg;
-	struct i2o_controller *c;
-	u32 __user *user_msg;
-	u32 *reply =3D NULL;
-	u32 __user *user_reply =3D NULL;
-	u32 size =3D 0;
-	u32 reply_size =3D 0;
-	u32 rcode =3D 0;
-	struct i2o_dma sg_list[SG_TABLESIZE];
-	u32 sg_offset =3D 0;
-	u32 sg_count =3D 0;
-	int sg_index =3D 0;
-	u32 i =3D 0;
-	i2o_status_block *sb;
-	struct i2o_message *msg;
-	unsigned int iop;
-
-	if (get_user(iop, &cmd->iop) || get_user(user_msg, &cmd->msg))
-		return -EFAULT;
-
-	c =3D i2o_find_iop(iop);
-	if (!c) {
-		osm_warn("controller %d not found\n", iop);
-		return -ENXIO;
-	}
-
-	sb =3D c->status_block.virt;
-
-	if (get_user(size, &user_msg[0]))
-		return -EFAULT;
-	size =3D size >> 16;
-
-	if (size > sb->inbound_frame_size) {
-		osm_warn("size of message > inbound_frame_size");
-		return -EFAULT;
-	}
-
-	user_reply =3D &user_msg[size];
-
-	size <<=3D 2;		// Convert to bytes
-
-	msg =3D i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	rcode =3D -EFAULT;
-	/* Copy in the user's I2O command */
-	if (copy_from_user(msg, user_msg, size))
-		goto out;
-
-	if (get_user(reply_size, &user_reply[0]) < 0)
-		goto out;
-
-	reply_size >>=3D 16;
-	reply_size <<=3D 2;
-
-	reply =3D kzalloc(reply_size, GFP_KERNEL);
-	if (!reply) {
-		printk(KERN_WARNING "%s: Could not allocate reply buffer\n",
-		       c->name);
-		rcode =3D -ENOMEM;
-		goto out;
-	}
-
-	sg_offset =3D (msg->u.head[0] >> 4) & 0x0f;
-
-	memset(sg_list, 0, sizeof(sg_list[0]) * SG_TABLESIZE);
-	if (sg_offset) {
-		struct sg_simple_element *sg;
-		struct i2o_dma *p;
-
-		if (sg_offset * 4 >=3D size) {
-			rcode =3D -EFAULT;
-			goto cleanup;
-		}
-		// TODO 64bit fix
-		sg =3D (struct sg_simple_element *)((&msg->u.head[0]) +
-						  sg_offset);
-		sg_count =3D
-		    (size - sg_offset * 4) / sizeof(struct sg_simple_element);
-		if (sg_count > SG_TABLESIZE) {
-			printk(KERN_DEBUG "%s:IOCTL SG List too large (%u)\n",
-			       c->name, sg_count);
-			rcode =3D -EINVAL;
-			goto cleanup;
-		}
-
-		for (i =3D 0; i < sg_count; i++) {
-			int sg_size;
-
-			if (!(sg[i].flag_count & 0x10000000
-			      /*I2O_SGL_FLAGS_SIMPLE_ADDRESS_ELEMENT */ )) {
-				printk(KERN_DEBUG
-				       "%s:Bad SG element %d - not simple (%x)\n",
-				       c->name, i, sg[i].flag_count);
-				rcode =3D -EINVAL;
-				goto sg_list_cleanup;
-			}
-			sg_size =3D sg[i].flag_count & 0xffffff;
-			p =3D &(sg_list[sg_index]);
-			if (i2o_dma_alloc(&c->pdev->dev, p, sg_size)) {
-			/* Allocate memory for the transfer */
-				printk(KERN_DEBUG
-				       "%s: Could not allocate SG buffer - size =3D %d buffer number %=
d of %d\n",
-				       c->name, sg_size, i, sg_count);
-				rcode =3D -ENOMEM;
-				goto sg_list_cleanup;
-			}
-			sg_index++;
-			/* Copy in the user's SG buffer if necessary */
-			if (sg[i].
-			    flag_count & 0x04000000 /*I2O_SGL_FLAGS_DIR */ ) {
-				// TODO 64bit fix
-				if (copy_from_user
-				    (p->virt, (void __user *)sg[i].addr_bus,
-				     sg_size)) {
-					printk(KERN_DEBUG
-					       "%s: Could not copy SG buf %d FROM user\n",
-					       c->name, i);
-					rcode =3D -EFAULT;
-					goto sg_list_cleanup;
-				}
-			}
-			sg[i].addr_bus =3D p->phys;
-		}
-	}
-
-	rcode =3D i2o_msg_post_wait(c, msg, 60);
-	msg =3D NULL;
-	if (rcode) {
-		reply[4] =3D ((u32) rcode) << 24;
-		goto sg_list_cleanup;
-	}
-
-	if (sg_offset) {
-		u32 rmsg[I2O_OUTBOUND_MSG_FRAME_SIZE];
-		/* Copy back the Scatter Gather buffers back to user space */
-		u32 j;
-		// TODO 64bit fix
-		struct sg_simple_element *sg;
-		int sg_size;
-
-		// re-acquire the original message to handle correctly the sg copy opera=
tion
-		memset(&rmsg, 0, I2O_OUTBOUND_MSG_FRAME_SIZE * 4);
-		// get user msg size in u32s
-		if (get_user(size, &user_msg[0])) {
-			rcode =3D -EFAULT;
-			goto sg_list_cleanup;
-		}
-		size =3D size >> 16;
-		size *=3D 4;
-		if (size > sizeof(rmsg)) {
-			rcode =3D -EFAULT;
-			goto sg_list_cleanup;
-		}
-
-		/* Copy in the user's I2O command */
-		if (copy_from_user(rmsg, user_msg, size)) {
-			rcode =3D -EFAULT;
-			goto sg_list_cleanup;
-		}
-		sg_count =3D
-		    (size - sg_offset * 4) / sizeof(struct sg_simple_element);
-
-		// TODO 64bit fix
-		sg =3D (struct sg_simple_element *)(rmsg + sg_offset);
-		for (j =3D 0; j < sg_count; j++) {
-			/* Copy out the SG list to user's buffer if necessary */
-			if (!
-			    (sg[j].
-			     flag_count & 0x4000000 /*I2O_SGL_FLAGS_DIR */ )) {
-				sg_size =3D sg[j].flag_count & 0xffffff;
-				// TODO 64bit fix
-				if (copy_to_user
-				    ((void __user *)sg[j].addr_bus, sg_list[j].virt,
-				     sg_size)) {
-					printk(KERN_WARNING
-					       "%s: Could not copy %p TO user %x\n",
-					       c->name, sg_list[j].virt,
-					       sg[j].addr_bus);
-					rcode =3D -EFAULT;
-					goto sg_list_cleanup;
-				}
-			}
-		}
-	}
-
-sg_list_cleanup:
-	/* Copy back the reply to user space */
-	if (reply_size) {
-		// we wrote our own values for context - now restore the user supplied o=
nes
-		if (copy_from_user(reply + 2, user_msg + 2, sizeof(u32) * 2)) {
-			printk(KERN_WARNING
-			       "%s: Could not copy message context FROM user\n",
-			       c->name);
-			rcode =3D -EFAULT;
-		}
-		if (copy_to_user(user_reply, reply, reply_size)) {
-			printk(KERN_WARNING
-			       "%s: Could not copy reply TO user\n", c->name);
-			rcode =3D -EFAULT;
-		}
-	}
-
-	for (i =3D 0; i < sg_index; i++)
-		i2o_dma_free(&c->pdev->dev, &sg_list[i]);
-
-cleanup:
-	kfree(reply);
-out:
-	if (msg)
-		i2o_msg_nop(c, msg);
-	return rcode;
-}
-#endif
-
 /*
  * IOCTL Handler
  */


--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-842rytcx2cX0Td7FPKZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFrqd+e/yOyVhhEJAQomxQ//X8sizlNfqGpWSdOGde1EaoVdWqmXV7VT
3KAuVTIpe4BEukePd0gVfVGE+GLQgPLc8MtIhVzTonF3eQDPp1nTYmwaPAPzdEJ3
9JrAWl56RYTVtmRe7MD2IM1EHvt988Neaf5G8R24I3jZGrhe95NXGIedxTrxRh/u
eBq4f15DqDn76YePQNidZDeVAbP3jWHlie5jHdqLnhd4P+vVFbk4zkjrc+H9/3Dc
WyxpbiUDgUJ9su2TxtZbYYnpJNXBTAQUasxHQRAtbGKnOtjrui3gBeK2NujcHj9c
D8FRUmidg+TncnnhGevE6MfN1hvMI1KdaRr+ZOhSbfGQnSfYLVLFZyEsdAZ8b7eg
mZiYRjRPSgkLJG+xsrWugS659mvQk39EbF7RAFLdWt+5CiLagPxPm8J2XKjT36QC
wI6FG9rv6tkaaU5Ia7VEpUidrXh26VTLEGh5atGYkZsM/tIsMum1nGE2Ow7OxJVr
aSaZ4c6gWAN+gNErduhbhpsBWXxalPJTI5OTJB+MTl/ANSjsIcOdYm1YeyPjAbJ/
3XbIWh4hf2fKI91VB89SG1FWZ+AM1I/Ke2axKuRsss6EXQz13t52vde26fVB3TOW
FQG7cO74EQxYz1Ahg9TIaHy1k/alg149ySASnX5ijX/aruwbeUcpNZyuOL7AtkfV
uvS7dWNP2es=
=2ojy
-----END PGP SIGNATURE-----

--=-842rytcx2cX0Td7FPKZp--

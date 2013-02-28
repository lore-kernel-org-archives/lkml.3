Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3B1BME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 20:12:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37816 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3B1BMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 20:12:01 -0500
Date: Wed, 27 Feb 2013 17:11:54 -0800
From: Tyler Hicks <tyhicks@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: allow userspace messaging to be disabled
Message-ID: <20130228011153.GA4385@boyd>
References: <20130228003042.GA8472@www.outflux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20130228003042.GA8472@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-02-27 16:30:42, Kees Cook wrote:
> When the userspace messaging (for the less common case of userspace key
> wrap/unwrap via ecryptfsd) is not needed, allow eCryptfs to build with
> it removed. This saves on kernel code size and reduces potential attack
> surface by removing the /dev/ecryptfs node.
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Tyler Hicks <tyhicks@canonical.com>

Thanks for the patch, Kees!

I took a glance over the code and noticed that ECRYPTFS_VERSIONING_MASK
needs some adjusting. Its value is what is used to populate the
/sys/fs/ecryptfs/version mask and ecryptfs-utils uses that to determine
what feature support is available in the kernel.

The ECRYPTFS_VERSIONING_PUBKEY and ECRYPTFS_VERSIONING_DEVMISC bits
should not be set if CONFIG_ECRYPTFS_FS_MESSAGING is not defined.

Also, I don't think it makes sense to expose ECRYPTFS_VERSIONING_MASK to
userspace through linux/ecryptfs.h. For starters, that's the purpose of
the sysfs entry but an #ifdef CONFIG_ECRYPTF_FS_MESSAGING isn't going to
make any sense there. So I suppose we'd want to move
ECRYPTFS_VERSIONING_MASK to fs/ecryptfs/ecryptfs_kernel.h at this time,
too.

Does that sound sane to you?

Tyler

> ---
>  fs/ecryptfs/Kconfig           |    8 ++++++++
>  fs/ecryptfs/Makefile          |    7 +++++--
>  fs/ecryptfs/ecryptfs_kernel.h |   27 +++++++++++++++++++++++++--
>  fs/ecryptfs/keystore.c        |    4 ++--
>  4 files changed, 40 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/ecryptfs/Kconfig b/fs/ecryptfs/Kconfig
> index e15ef38..434aa31 100644
> --- a/fs/ecryptfs/Kconfig
> +++ b/fs/ecryptfs/Kconfig
> @@ -12,3 +12,11 @@ config ECRYPT_FS
> =20
>  	  To compile this file system support as a module, choose M here: the
>  	  module will be called ecryptfs.
> +
> +config ECRYPT_FS_MESSAGING
> +	bool "Enable notifications for userspace key wrap/unwrap"
> +	depends on ECRYPT_FS
> +	help
> +	  Enables the /dev/ecryptfs entry for use by ecryptfsd. This allows
> +	  for userspace to wrap/unwrap file encryption keys by other
> +	  backends, like OpenSSL.
> diff --git a/fs/ecryptfs/Makefile b/fs/ecryptfs/Makefile
> index 2cc9ee4..49678a6 100644
> --- a/fs/ecryptfs/Makefile
> +++ b/fs/ecryptfs/Makefile
> @@ -1,7 +1,10 @@
>  #
> -# Makefile for the Linux 2.6 eCryptfs
> +# Makefile for the Linux eCryptfs
>  #
> =20
>  obj-$(CONFIG_ECRYPT_FS) +=3D ecryptfs.o
> =20
> -ecryptfs-objs :=3D dentry.o file.o inode.o main.o super.o mmap.o read_wr=
ite.o crypto.o keystore.o messaging.o miscdev.o kthread.o debug.o
> +ecryptfs-y :=3D dentry.o file.o inode.o main.o super.o mmap.o read_write=
=2Eo \
> +	      crypto.o keystore.o kthread.o debug.o
> +
> +ecryptfs-$(CONFIG_ECRYPT_FS_MESSAGING) +=3D messaging.o miscdev.o
> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index cfb4b9f..b33722c 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -399,7 +399,9 @@ struct ecryptfs_daemon {
>  	struct hlist_node euid_chain;
>  };
> =20
> +#ifdef CONFIG_ECRYPT_FS_MESSAGING
>  extern struct mutex ecryptfs_daemon_hash_mux;
> +#endif
> =20
>  static inline size_t
>  ecryptfs_lower_header_size(struct ecryptfs_crypt_stat *crypt_stat)
> @@ -604,6 +606,7 @@ int
>  ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *v=
alue,
>  		  size_t size, int flags);
>  int ecryptfs_read_xattr_region(char *page_virt, struct inode *ecryptfs_i=
node);
> +#ifdef CONFIG_ECRYPT_FS_MESSAGING
>  int ecryptfs_process_response(struct ecryptfs_daemon *daemon,
>  			      struct ecryptfs_message *msg, u32 seq);
>  int ecryptfs_send_message(char *data, int data_len,
> @@ -612,6 +615,24 @@ int ecryptfs_wait_for_response(struct ecryptfs_msg_c=
tx *msg_ctx,
>  			       struct ecryptfs_message **emsg);
>  int ecryptfs_init_messaging(void);
>  void ecryptfs_release_messaging(void);
> +#else
> +static inline int ecryptfs_init_messaging(void)
> +{
> +	return 0;
> +}
> +static inline void ecryptfs_release_messaging(void)
> +{ }
> +static inline int ecryptfs_send_message(char *data, int data_len,
> +					struct ecryptfs_msg_ctx **msg_ctx)
> +{
> +	return -ENOTCONN;
> +}
> +static inline int ecryptfs_wait_for_response(struct ecryptfs_msg_ctx *ms=
g_ctx,
> +					     struct ecryptfs_message **emsg)
> +{
> +	return -ENOMSG;
> +}
> +#endif
> =20
>  void
>  ecryptfs_write_header_metadata(char *virt,
> @@ -649,12 +670,11 @@ int ecryptfs_read_lower_page_segment(struct page *p=
age_for_ecryptfs,
>  				     size_t offset_in_page, size_t size,
>  				     struct inode *ecryptfs_inode);
>  struct page *ecryptfs_get_locked_page(struct inode *inode, loff_t index);
> -int ecryptfs_exorcise_daemon(struct ecryptfs_daemon *daemon);
> -int ecryptfs_find_daemon_by_euid(struct ecryptfs_daemon **daemon);
>  int ecryptfs_parse_packet_length(unsigned char *data, size_t *size,
>  				 size_t *length_size);
>  int ecryptfs_write_packet_length(char *dest, size_t size,
>  				 size_t *packet_size_length);
> +#ifdef CONFIG_ECRYPT_FS_MESSAGING
>  int ecryptfs_init_ecryptfs_miscdev(void);
>  void ecryptfs_destroy_ecryptfs_miscdev(void);
>  int ecryptfs_send_miscdev(char *data, size_t data_size,
> @@ -663,6 +683,9 @@ int ecryptfs_send_miscdev(char *data, size_t data_siz=
e,
>  void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx);
>  int
>  ecryptfs_spawn_daemon(struct ecryptfs_daemon **daemon, struct file *file=
);
> +int ecryptfs_exorcise_daemon(struct ecryptfs_daemon *daemon);
> +int ecryptfs_find_daemon_by_euid(struct ecryptfs_daemon **daemon);
> +#endif
>  int ecryptfs_init_kthread(void);
>  void ecryptfs_destroy_kthread(void);
>  int ecryptfs_privileged_open(struct file **lower_file,
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 2333203..32bd806 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -1168,7 +1168,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_a=
uth_tok *auth_tok,
>  	rc =3D ecryptfs_send_message(payload, payload_len, &msg_ctx);
>  	if (rc) {
>  		ecryptfs_printk(KERN_ERR, "Error sending message to "
> -				"ecryptfsd\n");
> +				"ecryptfsd: %d\n", rc);
>  		goto out;
>  	}
>  	rc =3D ecryptfs_wait_for_response(msg_ctx, &msg);
> @@ -1989,7 +1989,7 @@ pki_encrypt_session_key(struct key *auth_tok_key,
>  	rc =3D ecryptfs_send_message(payload, payload_len, &msg_ctx);
>  	if (rc) {
>  		ecryptfs_printk(KERN_ERR, "Error sending message to "
> -				"ecryptfsd\n");
> +				"ecryptfsd: %d\n", rc);
>  		goto out;
>  	}
>  	rc =3D ecryptfs_wait_for_response(msg_ctx, &msg);
> --=20
> 1.7.9.5
>=20
>=20
> --=20
> Kees Cook
> Chrome OS Security

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJRLq7YAAoJENaSAD2qAscKkKMP/RfjDjJ0eTe9LjZn6Q+R3WQp
UVXA7YN/jv2z3t9oHmyTx4bCqc2JrAHEyc07ItmXyuJUuIRoy6EqRiLqi5887d+T
hujDxySy+qLM+kMLzZwa6Qi1e7EisYBk9XovLm6SrKvfHNTc2Mo6QUZxUaTmoQ4f
FCwa80kKqadySv1M3JE+aDJHoUvYsuxkBAdOyOg2vvl0AZVVitA82qwQRCNvIPHq
IXuGLy1OJk8Ef6H6bI9ap8Zp5bimziUEI7KC/P4IdqeJD28E3OdfKdxLs4mfMsvY
YQ7TzhVbo/TPXlt8Utoh9X6cuvs69/V8bNktzbrNQGNqda2OjUrIR0cTjsYuJO93
DyD1qerp1r7FktsSa9tm5LZ48XslPnVv9Al/oiblpRPWKd7ig/tSSF0L65NuZMNh
YsuqsakpyrFxTcDevsakQTzSE0DJiPRyn4e+8akd+3mGU4IvKVyaNF7IMJKo8zdd
ARxZ++cszdMUCsLlOeXRBg/uAM534Im78Eh6ueNhDjTPnbzvaHibL9uKOddeowl8
Gnqbz44q5idvyGLzdLmVMz2E/8zufIDN3VjqwBS7svAVODkg/G2bgBCCfhNhATBK
+LWzbM75zS9AJPLPTeYsisRT6SFmIn4aOgsRLPSoLanyQ0FtF2mpoL2hqB9wka2a
CTfAAXdXMz37FSmkmEMr
=KoRY
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--

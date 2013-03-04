Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3CDJR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:17:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56589 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab3CDJR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:17:26 -0500
Date: Mon, 4 Mar 2013 01:17:21 -0800
From: Tyler Hicks <tyhicks@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org
Subject: Re: [PATCH v2] eCryptfs: allow userspace messaging to be disabled
Message-ID: <20130304091720.GA25248@boyd>
References: <20130228083937.GA27475@www.outflux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20130228083937.GA27475@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-02-28 00:39:37, Kees Cook wrote:
> When the userspace messaging (for the less common case of userspace key
> wrap/unwrap via ecryptfsd) is not needed, allow eCryptfs to build with
> it removed. This saves on kernel code size and reduces potential attack
> surface by removing the /dev/ecryptfs node.
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Tyler Hicks <tyhicks@canonical.com>
> ---
>=20
> v2:
>  - update version mask to reflect messaging feature presence.

Thanks for v2. I've pushed it to my next branch.

Tyler

>=20
> ---
>  fs/ecryptfs/Kconfig           |    8 ++++++++
>  fs/ecryptfs/Makefile          |    7 +++++--
>  fs/ecryptfs/ecryptfs_kernel.h |   40 +++++++++++++++++++++++++++++++++++=
+++--
>  fs/ecryptfs/keystore.c        |    4 ++--
>  include/linux/ecryptfs.h      |   12 ++----------
>  5 files changed, 55 insertions(+), 16 deletions(-)
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
> index cfb4b9f..a9df69e 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -172,6 +172,19 @@ ecryptfs_get_key_payload_data(struct key *key)
>  #define ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE 24
>  #define ECRYPTFS_ENCRYPTED_DENTRY_NAME_LEN (18 + 1 + 4 + 1 + 32)
> =20
> +#ifdef CONFIG_ECRYPT_FS_MESSAGING
> +# define ECRYPTFS_VERSIONING_MASK_MESSAGING (ECRYPTFS_VERSIONING_DEVMISC=
 \
> +					     | ECRYPTFS_VERSIONING_PUBKEY)
> +#else
> +# define ECRYPTFS_VERSIONING_MASK_MESSAGING 0
> +#endif
> +
> +#define ECRYPTFS_VERSIONING_MASK (ECRYPTFS_VERSIONING_PASSPHRASE \
> +				  | ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH \
> +				  | ECRYPTFS_VERSIONING_XATTR \
> +				  | ECRYPTFS_VERSIONING_MULTKEY \
> +				  | ECRYPTFS_VERSIONING_MASK_MESSAGING \
> +				  | ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION)
>  struct ecryptfs_key_sig {
>  	struct list_head crypt_stat_list;
>  	char keysig[ECRYPTFS_SIG_SIZE_HEX + 1];
> @@ -399,7 +412,9 @@ struct ecryptfs_daemon {
>  	struct hlist_node euid_chain;
>  };
> =20
> +#ifdef CONFIG_ECRYPT_FS_MESSAGING
>  extern struct mutex ecryptfs_daemon_hash_mux;
> +#endif
> =20
>  static inline size_t
>  ecryptfs_lower_header_size(struct ecryptfs_crypt_stat *crypt_stat)
> @@ -604,6 +619,7 @@ int
>  ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *v=
alue,
>  		  size_t size, int flags);
>  int ecryptfs_read_xattr_region(char *page_virt, struct inode *ecryptfs_i=
node);
> +#ifdef CONFIG_ECRYPT_FS_MESSAGING
>  int ecryptfs_process_response(struct ecryptfs_daemon *daemon,
>  			      struct ecryptfs_message *msg, u32 seq);
>  int ecryptfs_send_message(char *data, int data_len,
> @@ -612,6 +628,24 @@ int ecryptfs_wait_for_response(struct ecryptfs_msg_c=
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
> @@ -649,12 +683,11 @@ int ecryptfs_read_lower_page_segment(struct page *p=
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
> @@ -663,6 +696,9 @@ int ecryptfs_send_miscdev(char *data, size_t data_siz=
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
> diff --git a/include/linux/ecryptfs.h b/include/linux/ecryptfs.h
> index 2224a8c..8d5ab99 100644
> --- a/include/linux/ecryptfs.h
> +++ b/include/linux/ecryptfs.h
> @@ -6,9 +6,8 @@
>  #define ECRYPTFS_VERSION_MINOR 0x04
>  #define ECRYPTFS_SUPPORTED_FILE_VERSION 0x03
>  /* These flags indicate which features are supported by the kernel
> - * module; userspace tools such as the mount helper read
> - * ECRYPTFS_VERSIONING_MASK from a sysfs handle in order to determine
> - * how to behave. */
> + * module; userspace tools such as the mount helper read the feature
> + * bits from a sysfs handle in order to determine how to behave. */
>  #define ECRYPTFS_VERSIONING_PASSPHRASE            0x00000001
>  #define ECRYPTFS_VERSIONING_PUBKEY                0x00000002
>  #define ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH 0x00000004
> @@ -19,13 +18,6 @@
>  #define ECRYPTFS_VERSIONING_HMAC                  0x00000080
>  #define ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION   0x00000100
>  #define ECRYPTFS_VERSIONING_GCM                   0x00000200
> -#define ECRYPTFS_VERSIONING_MASK (ECRYPTFS_VERSIONING_PASSPHRASE \
> -				  | ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH \
> -				  | ECRYPTFS_VERSIONING_PUBKEY \
> -				  | ECRYPTFS_VERSIONING_XATTR \
> -				  | ECRYPTFS_VERSIONING_MULTKEY \
> -				  | ECRYPTFS_VERSIONING_DEVMISC \
> -				  | ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION)
>  #define ECRYPTFS_MAX_PASSWORD_LENGTH 64
>  #define ECRYPTFS_MAX_PASSPHRASE_BYTES ECRYPTFS_MAX_PASSWORD_LENGTH
>  #define ECRYPTFS_SALT_SIZE 8
> --=20
> 1.7.9.5
>=20
>=20
> --=20
> Kees Cook
> Chrome OS Security

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJRNGagAAoJENaSAD2qAscKPr0P/3Hs+4aWkiDVGWz4vHgjx0TY
H6+tSSJhHJrWyo3mjS5kDRfoemI86CTc4FO7oxXhwSNiOe6i25GKSfVesLi/+c1k
WHTqXDMCLlylJOiwW408YfloqaIdf8K/yencUI2bF+uLyTHXdFmC1RiElZIFl0LI
PWcJ8sLSv4/Mta0AEOGA1zsD7I16ekjIP0P0Vv7t9+AcQDV5P46HE3JAfkMEDfUP
fJjaiMjNRMKNJGo9haOectJfJmOdKEid9wav6GmbjyRZ/AK+Jv8AvkpPF/Zcpqa0
LLr1120BDqzEjlqsN6DwdXrYg6hG8fgt63Wjha8V8QjNxeE/SeqLg0KXBLyE1+Jr
BOvG4aCnXR1RSca8H6/HlZR/eokiRpUipvQ1hj+2UkmgAIMS7WC0MM25/7bjNuXc
gRNONd/75uyZy9A33/VfZBWR4i3KA3Pd0i1HTsvtOthgJHlrQ5uAwwxgWQ8jumR0
5UlaJJrlyp3GkY9Bd4votEAIYVlQoTCmzvW0Ag+qfyGshmAsFNBqKg7dnDvhniB8
s+3JC5qz2JWotZjrbZlGn15KPFTUwtdDdtPDZji5mDcuUyYC7BUARcuNK1uhgqBs
PcKOv3AO9/0wla5q58zB/NacksN+FteNOwfkLUdnLLhD6j9sXTmT4sbWG+M+EYCe
YgeuXFrDDXoiPqa2RDKG
=Kltk
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--

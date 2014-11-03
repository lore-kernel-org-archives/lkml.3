Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaKCQLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:11:40 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57720 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbaKCQLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:11:39 -0500
Date: Mon, 3 Nov 2014 10:11:02 -0600
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>,
        David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>, <m.szyprowski@samsung.com>,
        <k.opasiak@samsung.com>
Subject: Re: [PATCH v4] usb: gadget: f_fs: add "no_disconnect" mode
Message-ID: <20141103161102.GM27425@saruman>
Reply-To: <balbi@ti.com>
References: <1412860911-23985-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Jdw4pA1x1k2W7MG"
Content-Disposition: inline
In-Reply-To: <1412860911-23985-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9Jdw4pA1x1k2W7MG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 09, 2014 at 03:21:51PM +0200, Robert Baldyga wrote:
> Since we can compose gadgets from many functions, there is the problem
> related to gadget breakage while FunctionFS daemon being closed. FFS
> function is userspace code so there is no way to know when it will close
> files (it doesn't matter what is the reason of this situation, it can
> be daemon logic, program breakage, process kill or any other). So when
> we have another function in gadget which, for example, sends some amount
> of data, does some software update or implements some real-time functiona=
lity,
> we may want to keep the gadget connected despite FFS function is no longer
> functional.
>=20
> We can't just remove one of functions from gadget since it has been
> enumerated, so the only way to keep entire gadget working is to make
> broken FFS function deactivated but still visible to host. For this
> purpose this patch introduces "no_disconnect" mode. It can be enabled
> by setting mount option "no_disconnect=3D1", and results with defering
> function disconnect to the moment of reopen ep0 file or filesystem
> unmount. After closing all endpoint files, FunctionFS is set to state
> FFS_DEACTIVATED.
>=20
> When ffs->state =3D=3D FFS_DEACTIVATED:
> - function is still bound and visible to host,
> - setup requests are automatically stalled,
> - transfers on other endpoints are refused,
> - epfiles, except ep0, are deleted from the filesystem,
> - opening ep0 causes the function to be closes, and then FunctionFS
>   is ready for descriptors and string write,
> - unmounting of the FunctionFS instance causes the function to be closed.
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

David, you have been messing with ffs lately, can I get a Tested-by from
you on this patch ?

> ---
>=20
> Changelog:
>=20
> v4:
> - use ffs_data_reset() instead of ffs_data_clear() to reset ffs data
>   properly after ffs->ref refcount reach 0 (or under in no_disconnect
>   mode) in ffs_data_put() function
>=20
> v3: https://lkml.org/lkml/2014/10/9/170
> - change option name to more descriptive and less scary,
> - fix cleaning up on unmount (call ffs_data_closed() in ffs_fs_kill_sb(),
>   and ffs_data_clear() in ffs_data_closed() if ffs->opened is negative).
>=20
> v2: https://lkml.org/lkml/2014/10/7/109
> - delete epfiles, excepting ep0, when FFS is in "zombie" mode,
> - add description of FFS_ZOMBIE state,
> - minor cleanups.
>=20
> v1: https://lkml.org/lkml/2014/10/6/128
>=20
>  drivers/usb/gadget/function/f_fs.c | 42 +++++++++++++++++++++++++++++++-=
------
>  drivers/usb/gadget/function/u_fs.h | 22 ++++++++++++++++++++
>  2 files changed, 57 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/func=
tion/f_fs.c
> index 12dbdaf..2d47d4a 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -606,6 +606,8 @@ static unsigned int ffs_ep0_poll(struct file *file, p=
oll_table *wait)
>  		}
>  	case FFS_CLOSING:
>  		break;
> +	case FFS_DEACTIVATED:
> +		break;
>  	}
> =20
>  	mutex_unlock(&ffs->mutex);
> @@ -1152,6 +1154,7 @@ struct ffs_sb_fill_data {
>  	struct ffs_file_perms perms;
>  	umode_t root_mode;
>  	const char *dev_name;
> +	bool no_disconnect;
>  	struct ffs_data *ffs_data;
>  };
> =20
> @@ -1222,6 +1225,12 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_da=
ta *data, char *opts)
> =20
>  		/* Interpret option */
>  		switch (eq - opts) {
> +		case 13:
> +			if (!memcmp(opts, "no_disconnect", 13))
> +				data->no_disconnect =3D !!value;
> +			else
> +				goto invalid;
> +			break;
>  		case 5:
>  			if (!memcmp(opts, "rmode", 5))
>  				data->root_mode  =3D (value & 0555) | S_IFDIR;
> @@ -1286,6 +1295,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
>  			.gid =3D GLOBAL_ROOT_GID,
>  		},
>  		.root_mode =3D S_IFDIR | 0500,
> +		.no_disconnect =3D false,
>  	};
>  	struct dentry *rv;
>  	int ret;
> @@ -1302,6 +1312,7 @@ ffs_fs_mount(struct file_system_type *t, int flags,
>  	if (unlikely(!ffs))
>  		return ERR_PTR(-ENOMEM);
>  	ffs->file_perms =3D data.perms;
> +	ffs->no_disconnect =3D data.no_disconnect;
> =20
>  	ffs->dev_name =3D kstrdup(dev_name, GFP_KERNEL);
>  	if (unlikely(!ffs->dev_name)) {
> @@ -1333,6 +1344,7 @@ ffs_fs_kill_sb(struct super_block *sb)
>  	kill_litter_super(sb);
>  	if (sb->s_fs_info) {
>  		ffs_release_dev(sb->s_fs_info);
> +		ffs_data_closed(sb->s_fs_info);
>  		ffs_data_put(sb->s_fs_info);
>  	}
>  }
> @@ -1389,7 +1401,9 @@ static void ffs_data_opened(struct ffs_data *ffs)
>  	ENTER();
> =20
>  	atomic_inc(&ffs->ref);
> -	atomic_inc(&ffs->opened);
> +	if (atomic_add_return(1, &ffs->opened) =3D=3D 1)
> +		if (ffs->state =3D=3D FFS_DEACTIVATED)
> +			ffs_data_reset(ffs);
>  }
> =20
>  static void ffs_data_put(struct ffs_data *ffs)
> @@ -1411,9 +1425,22 @@ static void ffs_data_closed(struct ffs_data *ffs)
>  	ENTER();
> =20
>  	if (atomic_dec_and_test(&ffs->opened)) {
> -		ffs->state =3D FFS_CLOSING;
> -		ffs_data_reset(ffs);
> +		if (ffs->no_disconnect) {
> +			ffs->state =3D FFS_DEACTIVATED;
> +			if (ffs->epfiles) {
> +				ffs_epfiles_destroy(ffs->epfiles,
> +						   ffs->eps_count);
> +				ffs->epfiles =3D NULL;
> +			}
> +			if (ffs->setup_state =3D=3D FFS_SETUP_PENDING)
> +				__ffs_ep0_stall(ffs);
> +		} else {
> +			ffs->state =3D FFS_CLOSING;
> +			ffs_data_reset(ffs);
> +		}
>  	}
> +	if (atomic_read(&ffs->opened) < 0)
> +		ffs_data_reset(ffs);
> =20
>  	ffs_data_put(ffs);
>  }
> @@ -1588,7 +1615,6 @@ static void ffs_epfiles_destroy(struct ffs_epfile *=
epfiles, unsigned count)
>  	kfree(epfiles);
>  }
> =20
> -
>  static void ffs_func_eps_disable(struct ffs_function *func)
>  {
>  	struct ffs_ep *ep         =3D func->eps;
> @@ -1601,10 +1627,12 @@ static void ffs_func_eps_disable(struct ffs_funct=
ion *func)
>  		/* pending requests get nuked */
>  		if (likely(ep->ep))
>  			usb_ep_disable(ep->ep);
> -		epfile->ep =3D NULL;
> -
>  		++ep;
> -		++epfile;
> +
> +		if (epfile) {
> +			epfile->ep =3D NULL;
> +			++epfile;
> +		}
>  	} while (--count);
>  	spin_unlock_irqrestore(&func->ffs->eps_lock, flags);
>  }
> diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/func=
tion/u_fs.h
> index cd128e3..7bc0ca2 100644
> --- a/drivers/usb/gadget/function/u_fs.h
> +++ b/drivers/usb/gadget/function/u_fs.h
> @@ -93,6 +93,26 @@ enum ffs_state {
>  	FFS_ACTIVE,
> =20
>  	/*
> +	 * Function is visible to host, but it's not functional. All
> +	 * setup requests are stalled and transfers on another endpoints
> +	 * are refused. All epfiles, except ep0, are deleted so there
> +	 * is no way to perform any operations on them.
> +	 *
> +	 * This state is set after closing all functionfs files, when
> +	 * mount parameter "no_disconnect=3D1" has been set. Function will
> +	 * remain in deactivated state until filesystem is umounted or
> +	 * ep0 is opened again. In the second case functionfs state will
> +	 * be reset, and it will be ready for descriptors and strings
> +	 * writing.
> +	 *
> +	 * This is useful only when functionfs is composed to gadget
> +	 * with another function which can perform some critical
> +	 * operations, and it's strongly desired to have this operations
> +	 * completed, even after functionfs files closure.
> +	 */
> +	FFS_DEACTIVATED,
> +
> +	/*
>  	 * All endpoints have been closed.  This state is also set if
>  	 * we encounter an unrecoverable error.  The only
>  	 * unrecoverable error is situation when after reading strings
> @@ -251,6 +271,8 @@ struct ffs_data {
>  		kgid_t				gid;
>  	}				file_perms;
> =20
> +	bool no_disconnect;
> +
>  	/*
>  	 * The endpoint files, filled by ffs_epfiles_create(),
>  	 * destroyed by ffs_epfiles_destroy().
> --=20
> 1.9.1
>=20

--=20
balbi

--9Jdw4pA1x1k2W7MG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV6kWAAoJEIaOsuA1yqRE62MP/0fHAENpgJfAbcbUdZ4LdN6+
RPWWriTDtQzx4B6msFyL0dQwuQc2f8eGff3T5HUn/467TE7SF9MubsOEEnxsDV+J
7LZ50bGn6YCt85D7igKhGzwjueqs7e3PAIJ4qrXyUgm53NWDuh14YfImWlG+Q920
0gvmiy91Sw+UbSiq6v/qfBxLtfxCkJTUQaSkmELLT/c5eAm6mKJNByTdvztHFaMB
uPVTG7IjygXVHHkMa4+vkVrDCxwSHBSkjp5IH9eqgMiF9VfFGfycu+6PMJ75MF5q
auevVn1oBPnJPeEfvR2OItI/JuzaJLpJBoHg3eBc/sq5xe6qeZyubSNxZO4fr0An
shxtfXuwAuWSr1ujWpbKIU/jE30x6AVeUkw9r/rO/3dyfIBa6qwdHzi5WTvdwDtW
c4B7QBV1Z/j+ZkrRTob+Xap5NI3+0WITbvag1do8UWtMyt9hcLP5clr39hwjZjqq
gmcc5UDjHzcN3JzKnw09L1OPbnthyCBCXCD4c9j4HPvOnBw1T7IGGYNdNRl+6c80
jD76Mj5FQFksBIjTFZnY+rcWd6y14CL/u5rsjiilGxTcYL8lONvL6YxPN9XcZezt
hBkDntVSvJoQrpdqRQK3xhaWqLKtLpcjoVsLYIOZxRfZg0DSxlFgAZlh+daq+iJr
K5Zs6E8Ii/pS2b9s2f9v
=fFcZ
-----END PGP SIGNATURE-----

--9Jdw4pA1x1k2W7MG--

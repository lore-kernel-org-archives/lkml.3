Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbaGIJ1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:27:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:58402 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbaGIJ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:27:42 -0400
Date: Wed, 9 Jul 2014 11:27:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Message-ID: <20140709092733.GD9918@twins.programming.kicks-ass.net>
References: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5gxpn/Q6ypwruk0T"
Content-Disposition: inline
In-Reply-To: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 09:49:40AM -0700, kan.liang@intel.com wrote:
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -464,6 +464,12 @@ struct x86_pmu {
>  	 */
>  	struct extra_reg *extra_regs;
>  	unsigned int er_flags;
> +	/*
> +	 * EXTRA REG MSR can be accessed
> +	 * The extra registers are completely unrelated to each other.
> +	 * So it needs a flag for each extra register.
> +	 */
> +	bool		extra_msr_access[EXTRA_REG_MAX];
> =20
>  	/*
>  	 * Intel host/guest support (KVM)

# pahole -C extra_reg arch/x86/kernel/cpu/perf_event_intel.o
struct extra_reg {
        unsigned int               event;                /*     0     4 */
        unsigned int               msr;                  /*     4     4 */
        u64                        config_mask;          /*     8     8 */
        u64                        valid_mask;           /*    16     8 */
        int                        idx;                  /*    24     4 */

        /* size: 32, cachelines: 1, members: 5 */
        /* padding: 4 */
        /* last cacheline: 32 bytes */
};

There's still 4 empty bytes at the tail of extra_reg itself; would it
make sense to store the availability of the reg in there?

After all; the place we use it (x86_pmu_extra_regs) already has the
pointer to the structure.

--5gxpn/Q6ypwruk0T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTvQsFAAoJEHZH4aRLwOS66agQALVd6JbGx1wS33MHZvHTaiwY
bsFglzSSd+NWDXLa4e5slUjRcEVIMj9cocOGZ3uqmVA7tBeSwwvpz0HCf6OCshTo
bIctn5Zzh+FaeHkesTGpgO6lP+HDlnvf0ZbuGW2zJN1TTq3Q3PdchpvdhsBEUfDL
Azr06GBH4/Vsp+5ZA5vB3Q8uiwWZ6LdzEDQCQ/FKh0fmOE9rsR5+9XZ26Yh21+oK
pwPF6GdxtfK9EySfmXUvq/8VlnbMp8P8NHF2ibHAs69mAZQk4jWdyRArNSYILXgf
etbF3I3BoRyK93sll6/WLjklUfJhZA9mqFGLF57XSfaKmw2cxwFwSA3XQvBAXxRa
zZcbKJRZy4sabpgb9HN10tNP+dFx9HfYNBvt8u5QKgRmF9YUF+x9G5LNcw7eHshL
SkcQhiMdDlLzuIea3rrrX4o4l51nD47UYMkRiJ1pn5rkBzLEb/zOCz4lwN++4Asr
bDUs+pZWuNXBLu6YajHWqLv6VmDQePNUMK8EEF6MCekII7b4AsgIX8J1KJQH1nPp
scjs1MjSJdvhM4rFu2eYp0pkUTBxdI6t0egOzZRJAlzqCaa0hoWtpZRMjP6/N5YC
VHardwml5nfJ8Xx4PaMfmobhmB6CGcFyfd181kvkJbu2aZDL+nH92LCe8QZZ+y8X
MbCIJeHSQUabMwiLSeXL
=Xo5M
-----END PGP SIGNATURE-----

--5gxpn/Q6ypwruk0T--

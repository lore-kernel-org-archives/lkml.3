Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaGNLI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:08:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56474 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaGNLIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:08:18 -0400
Date: Mon, 14 Jul 2014 13:08:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V5 1/2] perf ignore LBR and extra_regs
Message-ID: <20140714110808.GU9918@twins.programming.kicks-ass.net>
References: <1404989984-3068-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WGtO2LJjz4IIGa2c"
Content-Disposition: inline
In-Reply-To: <1404989984-3068-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WGtO2LJjz4IIGa2c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 10, 2014 at 03:59:43AM -0700, kan.liang@intel.com wrote:
> +/*
> + * Under certain circumstances, access certain MSR may cause #GP.
> + * The function tests if the input MSR can be safely accessed.
> + */
> +static inline bool check_msr(unsigned long msr)
> +{
> +	u64 val_old, val_new, val_tmp;
> +
> +	/*
> +	 * Read the current value, change it and read it back to see if it
> +	 * matches, this is needed to detect certain hardware emulators
> +	 * (qemu/kvm) that don't trap on the MSR access and always return 0s.
> +	 */
> +	if (rdmsrl_safe(msr, &val_old))
> +		goto msr_fail;
> +	/*
> +	 * Only chagne it slightly,
> +	 * since the higher bits of some MSRs cannot be updated by wrmsrl.
> +	 * E.g. MSR_LBR_TOS
> +	 */
> +	val_tmp = val_old ^ 0x3UL;
> +	if (wrmsrl_safe(msr, val_tmp) ||
> +		rdmsrl_safe(msr, &val_new))
> +		goto msr_fail;
> +
> +	if (val_new != val_tmp)
> +		goto msr_fail;
> +
> +	/* Here it's sure that the MSR can be safely accessed.
> +	 * Restore the old value and return.
> +	 */
> +	wrmsrl(msr, val_old);
> +
> +	return true;
> +
> +msr_fail:
> +	return false;
> +}

I don't think we need the msr_fail thing, there's no state to clean up,
you can return false at all places you now have goto.

--WGtO2LJjz4IIGa2c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw7oYAAoJEHZH4aRLwOS65CoQAJt+z7kjiuECq8mGUIY0am1Y
sDth73WqL6TWBAvZXYGXcDiO+070kkKARQtwGB3K6QSgyNWpRWpNIiT1kjkrlXkC
xd2Y3EinnXg44G4J4cRS1tjAkBCGunMHkiDJBC1ndWllX+Qtvd5EdW/vwSP4lanJ
d4MiF7p3AHc6UEBL7GUuB+vrdAXoSS3qGiFrOzmPxFAD2SwYKFNJEvKexUOL8iSl
WfBYvghDAlY3QdSBwRUUArOh8z0gEFsRoNLPug0+wtUQpB1ZC9H9aEwHh51jpToE
HTc2bhwXmVx3mnP5kJzH3hRwAwO0RsTJkNvW8aP7aTxt7GdQ0iYSQKPElR6Kaq5p
/3B2zYIPsLt7wHzkDEiKI3FOq4qwDEUDnm6XumHBeo2mm5//CxmATzXks6r84qFA
Hzq7rKyMLEInFCSiJHlGfKqJWxfPT5coxi2JjoCmu6xvZOe5frlTzKICe+s4QSxN
PcwKtyhUd8AtMZRAMMYRZwKIS3+Udc3X5U82nlO6wpF1/1UXMpJRwV5SAMGS4DQ1
JdULHtDLaVrxbGJioWxzxXe0ip5nv//QKley31t/DIq3x2hUl5gmGoGPdRUniJh1
YaJt1CRwDfNseIP2JadJth7T9y3LYe+wpmXJHzdPZ+wzRtTFmi7prQfRsTc3PVG3
Loq9179hULarhk+Dhf7Z
=80gh
-----END PGP SIGNATURE-----

--WGtO2LJjz4IIGa2c--

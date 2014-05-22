Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaEVXth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:49:37 -0400
Received: from ozlabs.org ([103.22.144.67]:51630 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbaEVXtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:49:36 -0400
Date: Fri, 23 May 2014 09:49:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au, mingo@redhat.com,
        paulus@samba.org, imunsie@au1.ibm.com, acme@ghostprotocols.net,
        scottwood@freescale.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] powerpc/perf/hv-24x7: use kmem_cache instead of
 aligned stack allocations
Message-ID: <20140523094929.15f4613c@canb.auug.org.au>
In-Reply-To: <1400798673-27522-1-git-send-email-cody@linux.vnet.ibm.com>
References: <537E78AD.1040409@linux.vnet.ibm.com>
	<1400798673-27522-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mfBMgEwI/LHIUXFhiBDRx=Q"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mfBMgEwI/LHIUXFhiBDRx=Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Cody,

On Thu, 22 May 2014 15:44:25 -0700 Cody P Schafer <cody@linux.vnet.ibm.com>=
 wrote:
>
>  	if (ret) {
>  		if (success_expected)
>  			pr_err_ratelimited("hcall failed: %d %#x %#x %d =3D> 0x%lx (%ld) deta=
il=3D0x%x failing ix=3D%x\n",
>  					domain, offset, ix, lpar,
>  					ret, ret,
> -					result_buffer.buf.detailed_rc,
> -					result_buffer.buf.failing_request_ix);
> -		return ret;
> +					result_buffer->buf.detailed_rc,
> +					result_buffer->buf.failing_request_ix);
> +		goto out_hcall;
>  	}
> =20
> -	*res =3D be64_to_cpu(result_buffer.result);
> +	*res =3D be64_to_cpu(result_buffer->result);

not a biggie, but this last bit could be (remove the goto out_hcall and
teh label and then)

	} else {
		*res =3D be64_to_cpu(result_buffer->result);
	}

> +out_hcall:
> +	kfree(result_buffer);
> +out_resb:
> +	kfree(request_buffer);
> +out_reqb:
>  	return ret;
>  }
> =20

otherwise looks good to me.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/mfBMgEwI/LHIUXFhiBDRx=Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfo0OAAoJEMDTa8Ir7ZwVIEAP/0fagz+HvPvKBlqKjiHSr5/7
Vjy0oApDJx0nyyu6Y0+oLDXTM23SwJulM8gkrrVu2F+PA3nHAQYNLKhZ+rkPVf0n
QxlLBG0Tp1s5qQXB0N/PYZ2XTLzwzo8+Nv2u0RM2gH0GYlZPur3t6VlJfRiQnNTB
sbR7HeCpBb3/mKwvXOcveP/H8Wi2VQ6Eq+6PdVaPUATvP0CuOg6VRr0EbifqnYFG
iutgW3nwBULuMj2ytKl84KuOs9OXFUwRHv+7bQ/0BfHfOGiE3TaDjoOVCdyMFJfp
exK3l1bRzDFDrDC1N0azJBUK2L6NU2erOhGHn6D/9jY2JOXRN9RXfp/Hft5Sq0FN
8SloWb4g2wFfg3diZAnIRddJ6SG/8UrycFb+oZ8RO0kM/kIXiZQo0az2Uf18kuXd
V7pnTm8By0TXKT+VAZ2UaMAaXZgmG+gT1MPFLj2eotsaowLfo5u/FAFsXMTArEJC
ugEfasbPwOAzPqtVXDJUVpgjGqsUIbJ2wZxriQ4eaePLWag9vEP9Fhr7k9qqy/Nq
BBkHOf09XNSerxcBYqYkOG2WwEXObbLTDP7PN8XsieRiK1W71JtBQxZOb76VDhih
dginJw2L3NyZAagg9wxdvjUC9TdLzjgG1/Uw3LID5xaKjeHl7RKsuYreOUEg5p/I
u5U6HkJd/AdoquLqyAZ1
=nAI9
-----END PGP SIGNATURE-----

--Sig_/mfBMgEwI/LHIUXFhiBDRx=Q--

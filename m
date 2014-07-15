Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaGOOZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:25:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:57770 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaGOOZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:25:33 -0400
Date: Tue, 15 Jul 2014 16:25:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, acme@redhat.com, namhyung@kernel.org
Subject: Re: [PATCH v2 1/5] perf: add ability to sample machine state on
 interrupt
Message-ID: <20140715142524.GI9918@twins.programming.kicks-ass.net>
References: <1405384304-26816-1-git-send-email-eranian@google.com>
 <1405384304-26816-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TOcCsfss/f1fJPnO"
Content-Disposition: inline
In-Reply-To: <1405384304-26816-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TOcCsfss/f1fJPnO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 15, 2014 at 02:31:40AM +0200, Stephane Eranian wrote:
> @@ -618,6 +619,8 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
>  	data->weight = 0;
>  	data->data_src.val = 0;
>  	data->txn = 0;
> +	data->regs_intr.abi = PERF_SAMPLE_REGS_ABI_NONE;
> +	data->regs_intr.regs = NULL;
>  }

> +static void perf_sample_regs_intr(struct perf_regs *regs_intr,
> +				  struct pt_regs *regs)
> +{
> +	regs_intr->regs = regs;
> +	regs_intr->abi  = perf_reg_abi(current);
> +}

> @@ -4800,6 +4824,20 @@ void perf_prepare_sample(struct perf_event_header *header,
>  		data->stack_user_size = stack_size;
>  		header->size += size;
>  	}
> +
> +	if (sample_type & PERF_SAMPLE_REGS_INTR) {
> +		/* regs dump ABI info */
> +		int size = sizeof(u64);
> +
> +		perf_sample_regs_intr(&data->regs_intr, regs);
> +
> +		if (data->regs_intr.regs) {
> +			u64 mask = event->attr.sample_regs_intr;
> +			size += hweight64(mask) * sizeof(u64);
> +		}
> +
> +		header->size += size;
> +	}

Given that the prepare_sample hunk sets both regs_intr fields, the
addition to perf_sample_data_init() is entirely superfluous, no?

--TOcCsfss/f1fJPnO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxTnUAAoJEHZH4aRLwOS6hagP/2Dwhi5apwZLURHAj050Gqkg
5ERApt0B5t/nNZvOSWX/AYCdaqa7VsFNUzf0VhxoTWNAuRLq1Ar2Z5SbNMjylMfK
Q4QwzHczxoLtFBaOBnDZQ6oZFA9HsNHh5Gyw8t87vzbhLoIHme/8cRDZ5nnK5QH1
OW7ILrh16PDRGf+YabUSLMzlIEAE2XFB5gOGwXJj++ZY1ty9SsybrQCu0JWzhSYX
k+uINMB6jj3gC1lS/aCBhO3zd57SltxB+zTUUlfa/8iBjbj40+emXVD9MeFF6/bk
OT52wBbgxHgF6hJXCcxzbhh1Hubiy3g4TnnV5ya0bq99NGbzpQRuxdSBWadZXZIn
4jtRhzpicACN40MVuxdWZ44Nb9p2Y1GDw29hg6PtJPIsJrAoDYDC6064zKz2zbgK
Gt/bXgo3SoPeNJJZfB5By+irN+wCF8Wz0yMim9/sCwrV+Fc8/6xRGtO9VUshQdmN
M5z8UHATyD9voTsUQEcwoO8mIlElgZie/bbtyc654uWqpgL1dOyXopevekjiQe+h
Epv4n+3MTVr7s0E/ZXxwKrdAGS0FiOCOmHNYtocOK5RPItGnHeQ3rvKan+AjnA/u
R/D+g5ND92w6pWCOZlh4KBNt4u+3zQx4w2liOyYXbCt1U3F28ZW4WYYPsf9kGBdv
MXG0zHzipT50sf4LkuBH
=r0Nx
-----END PGP SIGNATURE-----

--TOcCsfss/f1fJPnO--

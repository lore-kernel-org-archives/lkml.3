Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaGOOQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:16:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:57729 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaGOOQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:16:36 -0400
Date: Tue, 15 Jul 2014 16:16:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, acme@redhat.com, namhyung@kernel.org
Subject: Re: [PATCH v2 1/5] perf: add ability to sample machine state on
 interrupt
Message-ID: <20140715141625.GH9918@twins.programming.kicks-ass.net>
References: <1405384304-26816-1-git-send-email-eranian@google.com>
 <1405384304-26816-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Za+rIOv72GXlfHR"
Content-Disposition: inline
In-Reply-To: <1405384304-26816-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9Za+rIOv72GXlfHR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 02:31:40AM +0200, Stephane Eranian wrote:
> @@ -595,7 +595,8 @@ struct perf_sample_data {
>  	struct perf_callchain_entry	*callchain;
>  	struct perf_raw_record		*raw;
>  	struct perf_branch_stack	*br_stack;
> -	struct perf_regs_user		regs_user;
> +	struct perf_regs		regs_user;
> +	struct perf_regs		regs_intr;
>  	u64				stack_user_size;
>  	u64				weight;
>  	/*
> @@ -618,6 +619,8 @@ static inline void perf_sample_data_init(struct perf_=
sample_data *data,
>  	data->weight =3D 0;
>  	data->data_src.val =3D 0;
>  	data->txn =3D 0;
> +	data->regs_intr.abi =3D PERF_SAMPLE_REGS_ABI_NONE;
> +	data->regs_intr.regs =3D NULL;
>  }

I don't think we've been very careful here; does the below make sense?

AFAICT we don't need to set stack_user_size at all,
perf_prepare_sample() will set it when required, and with the change to
perf_sample_regs_user() the same is true for the regs_user thing.

This again reduces the cost of perf_sample_data_init() to touching a
single cacheline.

I'm not entirely sure the ____cacheline_aligned makes sense though, the
previous stack line is probably touched already so any next cacheline is
the one, and one avg we'd gain 0.5 cachelines worth of data.



---
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a8c0f6..d27fec8118b1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -575,34 +575,40 @@ extern u64 perf_event_read_value(struct perf_event *e=
vent,
=20
=20
 struct perf_sample_data {
-	u64				type;
+	/*
+	 * Fields set by perf_sample_data_init(), group so as to
+	 * minimize the cachelines touched.
+	 */
+	u64				addr;
+	struct perf_raw_record		*raw;
+	struct perf_branch_stack	*br_stack;
+	u64				period;
+	u64				weight;
+	u64				txn;
+	union  perf_mem_data_src	data_src;
+
=20
+	/*
+	 * The other fields, optionally {set,used} by
+	 * perf_{prepare,output}_sample().
+	 */
+	u64				type;
 	u64				ip;
 	struct {
 		u32	pid;
 		u32	tid;
 	}				tid_entry;
 	u64				time;
-	u64				addr;
 	u64				id;
 	u64				stream_id;
 	struct {
 		u32	cpu;
 		u32	reserved;
 	}				cpu_entry;
-	u64				period;
-	union  perf_mem_data_src	data_src;
 	struct perf_callchain_entry	*callchain;
-	struct perf_raw_record		*raw;
-	struct perf_branch_stack	*br_stack;
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
-	u64				weight;
-	/*
-	 * Transaction flags for abort events:
-	 */
-	u64				txn;
-};
+} ____cacheline_aligned;
=20
 static inline void perf_sample_data_init(struct perf_sample_data *data,
 					 u64 addr, u64 period)
@@ -612,9 +618,6 @@ static inline void perf_sample_data_init(struct perf_sa=
mple_data *data,
 	data->raw  =3D NULL;
 	data->br_stack =3D NULL;
 	data->period =3D period;
-	data->regs_user.abi =3D PERF_SAMPLE_REGS_ABI_NONE;
-	data->regs_user.regs =3D NULL;
-	data->stack_user_size =3D 0;
 	data->weight =3D 0;
 	data->data_src.val =3D 0;
 	data->txn =3D 0;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c8b53c94d41d..926cd7aafc14 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4299,6 +4299,8 @@ perf_output_sample_regs(struct perf_output_handle *ha=
ndle,
 static void perf_sample_regs_user(struct perf_regs_user *regs_user,
 				  struct pt_regs *regs)
 {
+	regs_user->abi =3D PERF_SAMPLE_REGS_ABI_NONE;
+
 	if (!user_mode(regs)) {
 		if (current->mm)
 			regs =3D task_pt_regs(current);

--9Za+rIOv72GXlfHR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxTe5AAoJEHZH4aRLwOS6z/4P/A/gBN12VDl+jRzWCdxG/Dcj
pS78xmEhMkEefiYgTEcLh/4LFyRZrL4FCVSwNyi8H1cDrrfl4npwOXbczKmn1IPu
LvlYJQI6nu3m9t3OA4JyrPK3O1LOpg4LH6NaYamw0SrrVRsDTjzVJjo8eiqtigql
UmE201tF0+nK0VHTyKmItLDvzUsK4xZp8CDB+7btUS2MQhNFnrxuW8eQ2lPUq3DM
Zd4DHzo5Fi8x+WXMLDxWsNaCEhaX62y3yEMIVBGfEGNmR0emNeiqwbouKExdgMIm
54EXHNL9IRjt6nxsMQoYUYQKgucTTtxyD5HE5F0yDoaz8fmXHFHtELk+p+PCaqTt
CApBDXQQ1Hkiczx/1WvgH1SoQUuqjYKbseo5sUmp1bze2qeh4V2eRg1996Q1igS0
qXHaAAs9ovKtZzrpnscUzNsjptJ60dgbWJzzGH+QoNUshbSPc2sZE2A9FX3ZhuX4
R6z+CozEf0LUHQYbanxv2/BYioBtJyk2XUND5qfgWEX6mo1DDyDeWoQ9ZQgQf6ve
UVsJ9byYz1nFDB90eD1dP+L/G33KiOMOX86WS/rLpX9nVPx7WGsnr33BFEkmsr7P
2K3YiS/xWCpYjDwPcoI7d3Y6Yefch6peAfC9nT75Q1JuaXXaed3oMBkfpOB9cs/S
HICJ+qcGhJtwNnZtrQZ0
=R5s3
-----END PGP SIGNATURE-----

--9Za+rIOv72GXlfHR--

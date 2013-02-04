Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3BDLDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:03:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab3BDLDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:03:44 -0500
Date: Mon, 4 Feb 2013 12:03:39 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: amerilainen@nvidia.com, airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5,RESEND 4/8] gpu: host1x: Add debug support
Message-ID: <20130204110339.GA28134@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-5-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <1358250244-9678-5-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Cg3RjHbE/ToY9TFaTepwNzM7F+z6WVLxnLRXrh8AgOB
 izVado6n3YUCf5wRfaypiV9S03CTla8E4iDBU/QKjYnHAZQbH8
 6l4gRd+rf7M78E4GXVgodFYPn3yIZrojDL9pfVBwE/lV6krWVP
 IEgihPn9Nc3DKEa6jjWV40Wn3RTF8e43xsGAW3fwhhI/kvkDQi
 BQAq8FxagNUYRFz5tZ9ndHBymYGSf5fzBSTD6m+tVs91YW/vPi
 bjbitkbX76qVH6HCm2DoHgzIufzvRwXU6G+9JZkIHJHsKovxuo
 wV+Oy3ePYi8NtAEhTjYwmxiUQtFmTEb90GtF2PUgMa4BN2ts3F
 I/4spjlIC+36oHVHXOZ5gkJGEQ8zdxMm6O2sheGFMVTWktrdYl
 TTGpnS7XZMdjukMM9wqpanJp/YuljUeTwQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 15, 2013 at 01:44:00PM +0200, Terje Bergstrom wrote:
> diff --git a/drivers/gpu/host1x/debug.c b/drivers/gpu/host1x/debug.c
[...]
> +static pid_t host1x_debug_null_kickoff_pid;
> +unsigned int host1x_debug_trace_cmdbuf;
> +
> +static pid_t host1x_debug_force_timeout_pid;
> +static u32 host1x_debug_force_timeout_val;
> +static u32 host1x_debug_force_timeout_channel;

Please group static and non-static variables.

> diff --git a/drivers/gpu/host1x/debug.h b/drivers/gpu/host1x/debug.h
[...]
> +struct output {
> +	void (*fn)(void *ctx, const char *str, size_t len);
> +	void *ctx;
> +	char buf[256];
> +};

Do we really need this kind of abstraction? There really should be only
one location where debug information is obtained, so I don't see a need
for this.

> diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
[...]
>  struct host1x_syncpt_ops {
>  	void (*reset)(struct host1x_syncpt *);
>  	void (*reset_wait_base)(struct host1x_syncpt *);
> @@ -117,6 +133,7 @@ struct host1x {
>  	struct host1x_channel_ops channel_op;
>  	struct host1x_cdma_ops cdma_op;
>  	struct host1x_pushbuffer_ops cdma_pb_op;
> +	struct host1x_debug_ops debug_op;
>  	struct host1x_syncpt_ops syncpt_op;
>  	struct host1x_intr_ops intr_op;

Again, better to pass in a const pointer to the ops structure.

> diff --git a/drivers/gpu/host1x/hw/debug_hw.c b/drivers/gpu/host1x/hw/debug_hw.c

> +static int show_channel_command(struct output *o, u32 addr, u32 val, int *count)
> +{
> +	unsigned mask;
> +	unsigned subop;
> +
> +	switch (val >> 28) {
> +	case 0x0:

These can easily be derived by looking at the debug output, but it may
still make sense to assign symbolic names to them.

> +static void show_channel_word(struct output *o, int *state, int *count,
> +		u32 addr, u32 val, struct host1x_cdma *cdma)
> +{
> +	static int start_count, dont_print;

What if two processes read debug information at the same time?

> +static void do_show_channel_gather(struct output *o,
> +		phys_addr_t phys_addr,
> +		u32 words, struct host1x_cdma *cdma,
> +		phys_addr_t pin_addr, u32 *map_addr)
> +{
> +	/* Map dmaget cursor to corresponding mem handle */
> +	u32 offset;
> +	int state, count, i;
> +
> +	offset = phys_addr - pin_addr;
> +	/*
> +	 * Sometimes we're given different hardware address to the same
> +	 * page - in these cases the offset will get an invalid number and
> +	 * we just have to bail out.
> +	 */

Why's that?

> +	map_addr = host1x_memmgr_mmap(mem);
> +	if (!map_addr) {
> +		host1x_debug_output(o, "[could not mmap]\n");
> +		return;
> +	}
> +
> +	/* Get base address from mem */
> +	sgt = host1x_memmgr_pin(mem);
> +	if (IS_ERR(sgt)) {
> +		host1x_debug_output(o, "[couldn't pin]\n");
> +		host1x_memmgr_munmap(mem, map_addr);
> +		return;
> +	}

Maybe you should stick with one of "could not" or "couldn't". Makes it
easier to search for.

> +static void show_channel_gathers(struct output *o, struct host1x_cdma *cdma)
> +{
> +	struct host1x_job *job;
> +
> +	list_for_each_entry(job, &cdma->sync_queue, list) {
> +		int i;
> +		host1x_debug_output(o,
> +				"\n%p: JOB, syncpt_id=%d, syncpt_val=%d,"
> +				" first_get=%08x, timeout=%d"
> +				" num_slots=%d, num_handles=%d\n",
> +				job,
> +				job->syncpt_id,
> +				job->syncpt_end,
> +				job->first_get,
> +				job->timeout,
> +				job->num_slots,
> +				job->num_unpins);

This could go on fewer lines.

> +static void host1x_debug_show_channel_cdma(struct host1x *m,
> +	struct host1x_channel *ch, struct output *o, int chid)
> +{
[...]
> +	switch (cbstat) {
> +	case 0x00010008:

Again, symbolic names would be nice.

Thierry

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRD5WLAAoJEN0jrNd/PrOh9HIQAMFPQ8d/R6pvnKWOn1a1zJ1O
iAF73s3xcTtzQB1magCT3gnpGbvLcn4mW0oAN9fv+pE44lbMhOlnunEMNHVEuOsh
A6bALC0TImbUXn0lsWw9tc9WEvofSVfFlrj1MHEPZ87Rq662wT8eEg+5lFGRwj9D
VN4HzsQxVKzbQyhWyGehwSD7eSrjp1aWq0jdMmrwGxhj6pLyuhWJ0HFA28Z91J2b
gEeJP93N1bOqtEWFpu+E2T7j4XEUcqoRD53nAQADNZaTa0ORij6CKz1zxomw5HR4
3AvQWfbi74RvxKYP9TxlZUcv+mh64Uk7zn9YbGTogQMb+BV5IXwLKLyM+0PFhrnl
hN/urvTvFUycvc+ge+pAh+8+zeoJLbroc+fcyJ4YtzjUJEVsQ1/rTcZsY6FOhF+V
Am7blg3X0jGE/6nr8vvth3B7mHsC40wGgvrlPyWCRFf8tbE9xkSsO1yOeNLjcD8c
55QwipkI11tHdCTAzRfWNbap59LZq2p6rjzUOC6CUGI2HCF3FbLG4Onlw51qYXE6
VwU6WyejSG1YEAQ/Y2bRGTEVTbxGnmJpaMotbBSJwnhwcvgVN9bQQhmUDD5UZVpv
tdwCctkhmoTxCQIIMtGu2OGwXOrIWQU5NVyYqms9o2j2//Vq2m+DPAmHqpc10nLD
2JkYPcbb6lqlaQeHgmbc
=8Viw
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaHKD3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:29:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51654 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaHKD3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:29:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: akpm@linux-foundation.org, oleg@redhat.com, eparis@redhat.com,
        rgb@redhat.com, tixxdz@opendz.org, adobriyan@gmail.com,
        bill.c.roberts@gmail.com, linux-kernel@vger.kernel.org
References: <20140811024720.GA11337@devel.8.8.4.4>
Date: Sun, 10 Aug 2014 20:25:39 -0700
In-Reply-To: <20140811024720.GA11337@devel.8.8.4.4> (Daeseok Youn's message of
	"Mon, 11 Aug 2014 11:47:20 +0900")
Message-ID: <8738d3hfm4.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/a/lDRQ4LKDw9LmsTqNfco2zMN0ZWT3do=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4723]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daeseok Youn <daeseok.youn@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] proc: potential ERR_PTR dereference on proc_fill_cache()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daeseok Youn <daeseok.youn@gmail.com> writes:

> The d_hash_and_lookup() returns NULL or ERR_PTR on lookup
> failure.

Given that the only error condition can come from .d_hash and that proc
does not implement .d_hash if we want to do something with error returns
let's call BUG_ON. aka:

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f50d4be..49bc09c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1673,7 +1673,7 @@ bool proc_fill_cache(struct file *file, struct dir_context *ctx,
 	ino_t ino;
 
 	child = d_hash_and_lookup(dir, &qname);
+	BUG_ON(IS_ERR(child))
	if (!child) {
 		child = d_alloc(dir, &qname);
 		if (!child)
 			goto end_instantiate;

Or do you see something in d_hash_and_lookup that I am overlooking?

Eric


> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  fs/proc/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index f50d4be..49bc09c 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1673,7 +1673,7 @@ bool proc_fill_cache(struct file *file, struct dir_context *ctx,
>  	ino_t ino;
>  
>  	child = d_hash_and_lookup(dir, &qname);
> -	if (!child) {
> +	if (IS_ERR_OR_NULL(child)) {
>  		child = d_alloc(dir, &qname);
>  		if (!child)
>  			goto end_instantiate;

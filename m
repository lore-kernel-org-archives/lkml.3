Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbaEMLtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:49:25 -0400
Received: from mail.efficios.com ([78.47.125.74]:39866 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759892AbaEMLtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:49:20 -0400
Date: Tue, 13 May 2014 11:49:17 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: George Spelvin <linux@horizon.com>
Cc: john stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Message-ID: <754400443.15527.1399981757731.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140513024519.31594.qmail@ns.horizon.com>
References: <20140513024519.31594.qmail@ns.horizon.com>
Subject: Re: [PATCH 1/2] timekeeping: Use unsigned int for seqlock sequence
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF29 (Linux)/8.0.5_GA_5839)
Thread-Topic: timekeeping: Use unsigned int for seqlock sequence
Thread-Index: lTrnE8NT41d+h4wxQcg6cdOWOUTHAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "George Spelvin" <linux@horizon.com>
> To: "john stultz" <john.stultz@linaro.org>, linux@horizon.com
> Cc: linux-kernel@vger.kernel.org, "mathieu desnoyers" <mathieu.desnoyers@efficios.com>
> Sent: Monday, May 12, 2014 10:45:19 PM
> Subject: [PATCH 1/2] timekeeping: Use unsigned int for seqlock sequence
> 
> read_seqlock_begin returns an int, so using "unsigned long" to
> hold the return value is harmless, but a waste.

Did you try comparing this to changing read_seqlock to return
an "unsigned long" instead ? Does it change the executable
size at all ?

Seq locks correctness depends on ensuring the sequence
counter does not overflow. Strictly speaking, a 64-bit
value provides a stronger no-overflow guarantee than
a 32-bit value, even though it is already unlikely that
the 32-bit value will ever overflow in a sane system.
Therefore, I'd be tempted to use "unsigned long" if
possible if it's not significantly more expensive.

Thoughts ?

Thanks,

Mathieu

> 
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
>  kernel/time/timekeeping.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index f7df8ea217..14e703e5bd 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -300,7 +300,7 @@ static void timekeeping_forward_now(struct timekeeper
> *tk)
>  int __getnstimeofday(struct timespec *ts)
>  {
>  	struct timekeeper *tk = &timekeeper;
> -	unsigned long seq;
> +	unsigned int seq;
>  	s64 nsecs = 0;
>  
>  	do {
> @@ -399,7 +399,7 @@ EXPORT_SYMBOL_GPL(ktime_get_ts);
>  void timekeeping_clocktai(struct timespec *ts)
>  {
>  	struct timekeeper *tk = &timekeeper;
> -	unsigned long seq;
> +	unsigned int seq;
>  	u64 nsecs;
>  
>  	WARN_ON(timekeeping_suspended);
> @@ -447,7 +447,7 @@ EXPORT_SYMBOL(ktime_get_clocktai);
>  void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec
>  *ts_real)
>  {
>  	struct timekeeper *tk = &timekeeper;
> -	unsigned long seq;
> +	unsigned int seq;
>  	s64 nsecs_raw, nsecs_real;
>  
>  	WARN_ON_ONCE(timekeeping_suspended);
> @@ -700,7 +700,7 @@ EXPORT_SYMBOL_GPL(ktime_get_real);
>  void getrawmonotonic(struct timespec *ts)
>  {
>  	struct timekeeper *tk = &timekeeper;
> -	unsigned long seq;
> +	unsigned int seq;
>  	s64 nsecs;
>  
>  	do {
> @@ -720,7 +720,7 @@ EXPORT_SYMBOL(getrawmonotonic);
>  int timekeeping_valid_for_hres(void)
>  {
>  	struct timekeeper *tk = &timekeeper;
> -	unsigned long seq;
> +	unsigned int seq;
>  	int ret;
>  
>  	do {
> @@ -739,7 +739,7 @@ int timekeeping_valid_for_hres(void)
>  u64 timekeeping_max_deferment(void)
>  {
>  	struct timekeeper *tk = &timekeeper;
> -	unsigned long seq;
> +	unsigned int seq;
>  	u64 ret;
>  
>  	do {
> @@ -1546,7 +1546,7 @@ struct timespec current_kernel_time(void)
>  {
>  	struct timekeeper *tk = &timekeeper;
>  	struct timespec now;
> -	unsigned long seq;
> +	unsigned int seq;
>  
>  	do {
>  		seq = read_seqcount_begin(&timekeeper_seq);
> @@ -1562,7 +1562,7 @@ struct timespec get_monotonic_coarse(void)
>  {
>  	struct timekeeper *tk = &timekeeper;
>  	struct timespec now, mono;
> -	unsigned long seq;
> +	unsigned int seq;
>  
>  	do {
>  		seq = read_seqcount_begin(&timekeeper_seq);
> @@ -1596,7 +1596,7 @@ void get_xtime_and_monotonic_and_sleep_offset(struct
> timespec *xtim,
>  				struct timespec *wtom, struct timespec *sleep)
>  {
>  	struct timekeeper *tk = &timekeeper;
> -	unsigned long seq;
> +	unsigned int seq;
>  
>  	do {
>  		seq = read_seqcount_begin(&timekeeper_seq);
> @@ -1647,7 +1647,7 @@ ktime_t ktime_get_update_offsets(ktime_t *offs_real,
> ktime_t *offs_boot,
>  ktime_t ktime_get_monotonic_offset(void)
>  {
>  	struct timekeeper *tk = &timekeeper;
> -	unsigned long seq;
> +	unsigned int seq;
>  	struct timespec wtom;
>  
>  	do {
> --
> 1.9.2
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

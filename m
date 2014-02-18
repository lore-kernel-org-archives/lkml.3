Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbaBRNCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:02:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbaBRNCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:02:35 -0500
Date: Tue, 18 Feb 2014 14:02:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com
Subject: Re: [PATCH 08/21] perf, c2c: Rework setup code to prepare for
 features
Message-ID: <20140218130223.GH4343@krava.brq.redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392053356-23024-9-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392053356-23024-9-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 12:29:03PM -0500, Don Zickus wrote:
> A basic patch that re-arranges some of the c2c code and adds a couple
> of small features to lay the ground work for the rest of the patch
> series.
> 
> Changes include:
> 
> o reworking the report path
> o creating an initial entry struct
> o replace preprocess_sample with simpler calls
> o rework raw output to handle separators
> o remove phys id gunk
> o add some generic options
> 
> There isn't much meat in this patch just a bunch of code movement and cleanups.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---

SNIP

>  static int perf_c2c__process_sample(struct perf_tool *tool,
>  				    union perf_event *event,
> @@ -153,20 +198,63 @@ static int perf_c2c__process_sample(struct perf_tool *tool,
>  				    struct machine *machine)
>  {
>  	struct perf_c2c *c2c = container_of(tool, struct perf_c2c, tool);
> -	struct addr_location al;
> -	int err = 0;
> +	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
> +	struct mem_info *mi;
> +	struct thread *thread;
> +	struct c2c_entry *entry;
> +	sample_handler f;
> +	int err = -1;
> +
> +	if (evsel->handler.func == NULL)
> +		return 0;
> +
> +	thread = machine__find_thread(machine, sample->tid);
> +	if (thread == NULL)
> +		goto err;
> +
> +	mi = machine__resolve_mem(machine, thread, sample, cpumode);
> +	if (mi == NULL)
> +		goto err;
>  
> -	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
> -		pr_err("problem processing %d event, skipping it.\n",
> -		       event->header.type);
> -		return -1;
> +	if (c2c->raw_records) {
> +		perf_sample__fprintf(sample, ' ', "raw input", mi, stdout);
> +		free(mi);
> +		return 0;
>  	}
>  
> -	if (evsel->handler.func != NULL) {
> -		sample_handler f = evsel->handler.func;
> -		err = f(c2c, sample, &al);
> +	entry = c2c_entry__new(sample, thread, mi, cpumode);
> +	if (entry == NULL)
> +		goto err_mem;
> +
> +	f = evsel->handler.func;
> +	err = f(c2c, sample, entry);
> +	if (err)
> +		goto err_entry;
> +
> +	return 0;

this looks like new mode for namhyung's iterator patchset
http://marc.info/?l=linux-kernel&m=138967747319160&w=2

git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
perf/cumulate-v8

jirka

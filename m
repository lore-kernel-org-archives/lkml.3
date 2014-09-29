Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaI2ECu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:02:50 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:33088 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaI2ECt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:02:49 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4 2/2] perf tool: improves DSO long names lookup speed with rbtree
References: <1411573540-8765-1-git-send-email-Waiman.Long@hp.com>
	<1411573540-8765-3-git-send-email-Waiman.Long@hp.com>
	<20140926142234.GC3879@kernel.org>
Date: Mon, 29 Sep 2014 13:02:47 +0900
In-Reply-To: <20140926142234.GC3879@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Fri, 26 Sep 2014 11:22:34 -0300")
Message-ID: <87d2afhy54.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014 11:22:34 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Sep 24, 2014 at 11:45:40AM -0400, Waiman Long escreveu:
>> +	/*
>> +	 * Find node with the matching name
>> +	 */
>> +	while (*p) {
>> +		struct dso *this = rb_entry(*p, struct dso, rb_node);
>> +		long rc = (long)strcmp(name, this->long_name);
>> +
>> +		parent = *p;
>> +		if (rc == 0) {
>> +			/*
>> +			 * In case the new DSO is a duplicate of an existing
>> +			 * one, print an one-time warning & sort the entry
>> +			 * by its DSO address.
>> +			 */
>> +			if (!dso || (dso == this))
>> +				return this;	/* Find matching dso */
>> +			/*
>> +			 * The kernel DSOs may have duplicated long name,
>> +			 * so don't print warning for them.
>> +			 */
>> +			if (!warned && !strstr(name, "kernel.kallsyms")
>> +				    && !strstr(name, "/vmlinux")) {
>> +				pr_warning("Duplicated dso long name: %s\n",
>> +					   name);
>
> Huh? Can you elaborate on this? Ho can we add multiple DSOs with the
> exact same name into this tree? Have you actually seen this in practice?
> I guess so, judging by the comment above ("may have").

I guess it's because we split maps and dsos by section name (for kernel
only).  Please look at dso__load_sym() - If map_groups__find_by_name()
with short name + section name fails, it creates a new dso and map, and
then curr_dso->long_name will be set as dso->long_name.

Thanks,
Namhyung


>
> I'll try the patch to see if I get these warnings...
>
> But initial reaction to these long casts and fallbacking to pointer
> arithmetic for tree searching/inserting looked ugly :-\

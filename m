Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaAMXz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:55:58 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:49777 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaAMXzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:55:52 -0500
X-AuditID: 9c93017d-b7b41ae000004b3e-c9-52d47d06d8e7
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 10/28] perf report: Cache cumulative callchains
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
	<1389170793-21926-11-git-send-email-namhyung@kernel.org>
	<20140109180627.GC11793@krava.brq.redhat.com>
Date: Tue, 14 Jan 2014 08:55:50 +0900
In-Reply-To: <20140109180627.GC11793@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 9 Jan 2014 19:06:28 +0100")
Message-ID: <871u0bbfnd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Thanks for reminding me. :)

On Thu, 9 Jan 2014 19:06:28 +0100, Jiri Olsa wrote:
> On Wed, Jan 08, 2014 at 05:46:15PM +0900, Namhyung Kim wrote:

[SNIP]
>> +	/*
>> +	 * Check if there's duplicate entries in the callchain.
>> +	 * It's possible that it has cycles or recursive calls.
>> +	 */
>> +	for (i = 0; i < iter->curr; i++) {
>> +		if (hist_entry__cmp(he_cache[i], &he_tmp) == 0)
>
> we need here:
> 			iter->he = he_cache[i];
>
>> +			return 0;
>> +	}
>
> otherwise iter->he and al are not in sync and 
> hist_entry__inc_addr_samples fails in hist_iter_cb

Right.  But the point of the he_cache is to skip duplicate entries.  So
I'd like to change it like setting it to NULL and check it before the
callback function:

	while (iter->next_entry(iter, al)) {
		err = iter->add_next_entry(iter, al);
                if (err)
			break;

		if (iter->he && iter->add_entry_cb) {
			err = iter->add_entry_cb(iter, al, ...);
			if (err)
				break;
		}
        }

What do you think?

Thanks,
Namhyung

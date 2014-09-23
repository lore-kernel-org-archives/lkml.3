Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaIWOCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:02:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38599 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755320AbaIWOCN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:02:13 -0400
From: Arun Sharma <asharma@fb.com>
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 2/2] perf callchain: Use global caching provided by
 libunwind
Thread-Topic: [PATCH 2/2] perf callchain: Use global caching provided by
 libunwind
Thread-Index: AQHP1vfl0/2MVuC7mkWssyM4hJeBRZwOv5WA
Date: Tue, 23 Sep 2014 14:01:22 +0000
Message-ID: <54217D09.40500@fb.com>
References: <1411453828-14832-1-git-send-email-namhyung@kernel.org>
 <1411453828-14832-2-git-send-email-namhyung@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29397465D300BE48B6B492D14EFF01D4@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-23_05:2014-09-23,2014-09-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=41.0962989792247
 compositescore=0.0999825551994918 urlsuspect_oldscore=0.999233537697313
 suspectscore=0 recipient_domain_to_sender_totalscore=77 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=57
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.0999825551994918 spamscore=0
 recipient_to_sender_domain_totalscore=57 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409230132
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/14, 12:00 PM, Namhyung Kim wrote:

> +	unw_set_caching_policy(addr_space, UNW_CACHE_GLOBAL);

The result is a bit surprising for me. In micro benchmarking (eg:
Lperf-simple), the per-thread policy is generally faster because it
doesn't involve locking.

libunwind/tests/Lperf-simple
unw_getcontext : cold avg=  109.673 nsec, warm avg=   28.610 nsec
unw_init_local : cold avg=  259.876 nsec, warm avg=    9.537 nsec
no cache        : unw_step : 1st= 3258.387 min= 2922.331 avg= 3002.384 nsec
global cache    : unw_step : 1st= 1192.093 min=  960.486 avg=  982.208 nsec
per-thread cache: unw_step : 1st=  429.153 min=  113.533 avg=  121.762 nsec

I can see how the global policy would involve less memory allocation
because of shared data structures. Curious about the reason for the
speedup (specifically if libunwind should change the defaults for the
non-local unwinding case).

  -Arun


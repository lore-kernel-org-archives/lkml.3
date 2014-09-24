Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaIXBEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 21:04:46 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54693 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaIXBEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 21:04:45 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 2/2] perf callchain: Use global caching provided by libunwind
References: <1411453828-14832-1-git-send-email-namhyung@kernel.org>
	<1411453828-14832-2-git-send-email-namhyung@kernel.org>
	<20140923122843.GF2979@krava.brq.redhat.com>
	<CAM9d7cgwSrqLNghb3Vdt-=c9w1iFq0wc-njVP4UxkWD4hXCteg@mail.gmail.com>
Date: Wed, 24 Sep 2014 10:04:43 +0900
In-Reply-To: <CAM9d7cgwSrqLNghb3Vdt-=c9w1iFq0wc-njVP4UxkWD4hXCteg@mail.gmail.com>
	(Namhyung Kim's message of "Tue, 23 Sep 2014 21:53:43 +0900")
Message-ID: <878ul9ltg4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014 21:53:43 +0900, Namhyung Kim wrote:
> On Tue, Sep 23, 2014 at 9:28 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> On Tue, Sep 23, 2014 at 03:30:28PM +0900, Namhyung Kim wrote:
>>> The libunwind provides two caching policy which are global and
>>> per-thread.  As perf unwinds callchains in a single thread, it'd
>>> sufficient to use global caching.
>>>
>>> This speeds up my perf report from 14s to 7s on a ~260MB data file.
>>> Although the output contains a slight difference (~0.01% in terms of
>>> number of lines printed) on callchains which were not resolved.
>>
>> hum, the speedup is nice, but what was the diff output.. any example?
>> The new version does not print some lines or different ones?
>
> I don't have the result now - will post the diff when I go to the
> office tomorrow.  But IIRC new version only adds new lines..

Okay, this is the result..  But it doesn't always make a difference.  I
can see it produces exactly same output for other (even bigger) data files.


  $ diff -U0 callchain-result.{old,new}
  --- callchain-result.old	2014-09-23 14:52:29.630711402 +0900
  +++ callchain-result.new	2014-09-23 14:52:52.709505500 +0900
  @@ -5322,0 +5323,9 @@
  +                          |          |          |          
  +                          |          |           --0.00%-- 0x406520
  +                          |          |                     0x4064f0
  +                          |          |                     |          
  +                          |          |                     |--0.00%-- 0x1ad52a0
  +                          |          |                     |          
  +                          |          |                     |--0.00%-- 0x1a0f2e0
  +                          |          |                     |          
  +                          |          |                      --0.00%-- 0x1a9e0c0
  @@ -108899,0 +108909,3 @@
  +                            |          |          0x406520
  +                            |          |          0x4064f0
  +                            |          |          0x1a9e0c0
  @@ -180410,0 +180423,9 @@
  +                          |          |          
  +                          |           --0.00%-- 0x406520
  +                          |                     0x4064f0
  +                          |                     |          
  +                          |                     |--0.00%-- 0x1ad52a0
  +                          |                     |          
  +                          |                     |--0.00%-- 0x1a0f2e0
  +                          |                     |          
  +                          |                      --0.00%-- 0x1a9e0c0
  
  $ wc -l callchain-result.{old,new}
    191412 callchain-result.old
    191433 callchain-result.new
    382845 total


Thanks,
Namhyung

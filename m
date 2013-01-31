Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab3AaSOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:14:07 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:62538 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3AaSOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:14:05 -0500
Message-ID: <510AB468.8020904@gmail.com>
Date: Thu, 31 Jan 2013 11:14:00 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/25] perf top: Delete maps on exit
References: <1359653128-10433-1-git-send-email-acme@infradead.org> <1359653128-10433-3-git-send-email-acme@infradead.org>
In-Reply-To: <1359653128-10433-3-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/13 10:25 AM, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> Removing one more memory leak found with valgrind.

If you are spending time one memory consumption by perf-top one thing to 
look at is handling of terminated threads. Currently, terminated threads 
are stuck onto the dead_threads list and only cleaned up when perf 
terminates (perf_session__delete_dead_threads).

Since the thread entries can still be referenced in hists perhaps a 
refcnt is needed that indicates when the threads can be deleted. From 
there regular calls to perf_session__delete_dead_threads can be made. I 
needed to add a regular call to that function in my perf daemon to keep 
memory usage stable - but then I don't have lingering references.

A lot of work yes but will be needed if there is to be an official 
libperf.so that apps can leverage.

David


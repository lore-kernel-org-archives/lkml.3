Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaJCGvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 02:51:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbaJCGvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 02:51:18 -0400
Date: Fri, 3 Oct 2014 08:50:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf tools: Add option to copy events when queueing
Message-ID: <20141003065047.GN9764@krava.brq.redhat.com>
References: <1412267936-19827-1-git-send-email-yarygin@linux.vnet.ibm.com>
 <1412267936-19827-2-git-send-email-yarygin@linux.vnet.ibm.com>
 <20141003043421.GA24217@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003043421.GA24217@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 06:34:21AM +0200, Ingo Molnar wrote:
> 
> * Alexander Yarygin <yarygin@linux.vnet.ibm.com> wrote:
> 
> > When processing events the session code has an ordered samples 
> > queue which is used to time-sort events coming in across 
> > multiple mmaps. At a later point in time samples on the queue 
> > are flushed up to some timestamp at which point the event is 
> > actually processed.
> > 
> > When analyzing events live (ie., record/analysis path in the 
> > same command) there is a race that leads to corrupted events 
> > and parse errors which cause perf to terminate. The problem is 
> > that when the event is placed in the ordered samples queue it 
> > is only a reference to the event which is really sitting in the 
> > mmap buffer. Even though the event is queued for later 
> > processing the mmap tail pointer is updated which indicates to 
> > the kernel that the event has been processed. The race is 
> > flushing the event from the queue before it gets overwritten by 
> > some other event. For commands trying to process events live 
> > (versus just writing to a file) and processing a high rate of 
> > events this leads to parse failures and perf terminates.
> > 
> > Examples hitting this problem are 'perf kvm stat live', 
> > especially with nested VMs which generate 100,000+ traces per 
> > second, and a command processing scheduling events with a high 
> > rate of context switching -- e.g., running 'perf bench sched 
> > pipe'.
> > 
> > This patch offers live commands an option to copy the event 
> > when it is placed in the ordered samples queue.
> 
> What's the performance effect of this - i.e. by how much does CPU 
> use increase due to copying the events?
> 
> Wouldn't it be faster to fix this problem by updating the mmap 
> tail pointer only once the event has truly been consumed?

Alexander mentioned he'd loose data, because of userspace processing
being to slow:
http://marc.info/?l=linux-kernel&m=141111652424818&w=2

jirka

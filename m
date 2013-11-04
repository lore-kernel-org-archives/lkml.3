Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3KDILe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:11:34 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52698 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3KDILd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:11:33 -0500
X-AuditID: 9c93017d-b7cbaae00000368f-18-527756b313fe
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a ring buffer
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
	<1383029621-7384-11-git-send-email-namhyung@kernel.org>
	<20131101150910.GA18278@redhat.com> <20131101152232.GA2703@redhat.com>
	<20131103202037.GA2785@redhat.com>
Date: Mon, 04 Nov 2013 17:11:29 +0900
In-Reply-To: <20131103202037.GA2785@redhat.com> (Oleg Nesterov's message of
	"Sun, 3 Nov 2013 21:20:37 +0100")
Message-ID: <87txfs37ta.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Nov 2013 21:20:37 +0100, Oleg Nesterov wrote:
> On 11/01, Oleg Nesterov wrote:
>>
>> Ah, please ignore... handler_chain() is not self-serialized, so
>> tu->buffer needs locking/waiting too.
>
> Still I have to admit that I strongly dislike this yet another
> (and imho strange) memory pool. However, I am not going to argue
> because I can't suggest something better right now.

Okay.

>
> But. Perhaps it makes sense to at least add a couple of trivial
> helpers in 10/13? Something like arg_buf_get/put/init, just to
> simplify the potential changes.

Good idea.  How about something like below?


struct uprobe_cpu_buffer {
	struct mutex mutex;
	void *buf;
};
static struct uprobe_cpu_buffer __percpu *uprobe_cpu_buffer;
static DEFINE_MUTEX(uprobe_buffer_mutex);
static int uprobe_buffer_refcnt;

static int uprobe_buffer_init(void)
{
	int cpu, err_cpu;

	uprobe_cpu_buffer = alloc_percpu(struct uprobe_cpu_buffer);
	if (uprobe_cpu_buffer == NULL)
		return -ENOMEM;

	for_each_possible_cpu(cpu) {
		struct page *p = alloc_pages_node(cpu_to_node(cpu),
						  GFP_KERNEL, 0);
		if (p == NULL) {
			err_cpu = cpu;
			goto err;
		}
		per_cpu_ptr(uprobe_cpu_buffer, cpu)->buf = page_address(p);
		mutex_init(&per_cpu_ptr(uprobe_cpu_buffer, cpu)->mutex);
	}

	return 0;

err:
	for_each_possible_cpu(cpu) {
		if (cpu == err_cpu)
			break;
		free_page((unsigned long)per_cpu_ptr(uprobe_cpu_buffer, cpu)->buf);
	}

	free_percpu(uprobe_cpu_buffer);
	return -ENOMEM;
}

static int uprobe_buffer_enable(void)
{
	int ret = 0;

	mutex_lock(&uprobe_buffer_mutex);
	if (uprobe_buffer_refcnt++ == 0) {
		ret = uprobe_buffer_init();
		if (ret < 0)
			uprobe_buffer_refcnt--;
	}
	mutex_unlock(&uprobe_buffer_mutex);

	return ret;
}

static void uprobe_buffer_disable(void)
{
	mutex_lock(&uprobe_buffer_mutex);
	if (--uprobe_buffer_refcnt == 0) {
		free_percpu(uprobe_cpu_buffer);
		uprobe_cpu_buffer = NULL;
	}
	mutex_unlock(&uprobe_buffer_mutex);
}

static struct uprobe_cpu_buffer *uprobe_buffer_get(void)
{
	struct uprobe_cpu_buffer *ucb;
	int cpu;

	cpu = raw_smp_processor_id();
	ucb = per_cpu_ptr(uprobe_cpu_buffer, cpu);

	/*
	 * Use per-cpu buffers for fastest access, but we might migrate
	 * so the mutex makes sure we have sole access to it.
	 */
	mutex_lock(&ucb->mutex);

	return ucb;
}

static void uprobe_buffer_put(struct uprobe_cpu_buffer *ucb)
{
	mutex_unlock(&ucb->mutex);
}


Thanks,
Namhyung

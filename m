Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaCNNRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:17:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbaCNNRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:17:38 -0400
Date: Fri, 14 Mar 2014 14:17:35 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@redhat.com, jmario@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Speed up thread map generation
Message-ID: <20140314131734.GB5276@krava.redhat.com>
References: <1394745397-96149-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394745397-96149-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 05:16:37PM -0400, Don Zickus wrote:

SNIP

> +	event->fork.ptid = tgid;
> +	event->fork.pid  = tgid;
> +	event->fork.tid  = pid;
> +	event->fork.header.type = PERF_RECORD_FORK;
> +
> +	event->fork.header.size = (sizeof(event->fork) + machine->id_hdr_size);
> +
> +	if (process(tool, event, &synth_sample, machine) != 0)
> +		return -1;
> +
> +	return 0;
> +}
> +
>  int perf_event__synthesize_mmap_events(struct perf_tool *tool,
>  				       union perf_event *event,
>  				       pid_t pid, pid_t tgid,
> @@ -287,6 +309,11 @@ static int __event__synthesize_thread(union perf_event *comm_event,
>  	DIR *tasks;
>  	struct dirent dirent, *next;
>  	pid_t tgid;
> +	union perf_event *fork_event;
> +
> +	fork_event = malloc(sizeof(fork_event->fork) + machine->id_hdr_size);
> +	if (fork_event == NULL)
> +		return -1;

need to be freed

maybe we could move the allocation one level up,
same as for mmap_event and comm_event

otherwise I think the logic with FORK event is correct

jirka

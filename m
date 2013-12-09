Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835Ab3LITDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:03:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:11925 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753419Ab3LITDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:03:45 -0500
Date: Mon, 9 Dec 2013 14:03:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 01/14] tools lib traceevent: Get rid of malloc_or_die()
 in show_error()
Message-ID: <20131209140342.5f72298f@gandalf.local.home>
In-Reply-To: <20131209183009.GC8098@ghostprotocols.net>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-2-git-send-email-namhyung@kernel.org>
	<20131209183009.GC8098@ghostprotocols.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 15:30:09 -0300
Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:


> > +		error = malloc(MAX_ERR_STR_SIZE);
> > +		if (error == NULL) {
> > +			/* no memory */
> > +			*error_str = "failed to allocate memory";
> > +			return;
> 
> Can *error_str point to either malloc'ed or constant strings? Who
> releases the allocated memory?
> 

Good question. Perhaps we should have a flag that states if the string
is allocated or not. Or better yet, since the only reason it would be
pointing to a static string is if the string for error_str itself
failed to allocate. Then we could use a string within pevent for it:

static char *pevent_failed_error_alloc = "failed to allocate memory";

Then in the freeing of error str:

void pevent_free_error_str(error_str)
{
	if (error_str != pevent_failed_error_alloc)
		free(error_str);
}

-- Steve

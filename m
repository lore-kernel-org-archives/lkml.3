Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040Ab3LIQdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:33:00 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:30954 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932633Ab3LIQc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:32:58 -0500
Date: Mon, 9 Dec 2013 11:32:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 09/14] tools lib traceevent: Get rid of die() in
 add_right()
Message-ID: <20131209113256.67442b2a@gandalf.local.home>
In-Reply-To: <87fvq2mrw1.fsf@sejong.aot.lge.com>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-10-git-send-email-namhyung@kernel.org>
	<CAKb7Uvhhg2siBURLxTb2jgW_-5AUeK_yqRpEJgi0HW12zQTMyg@mail.gmail.com>
	<87fvq2mrw1.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Dec 2013 15:59:26 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Ilia,
> 
> On Mon, 9 Dec 2013 01:28:26 -0500, Ilia Mirkin wrote:
> > On Mon, Dec 9, 2013 at 12:34 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> >> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> >> ---
> >>  tools/lib/traceevent/parse-filter.c | 12 +++++++++---
> >>  1 file changed, 9 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> >> index 5efe66a682bd..a1ad609a860f 100644
> >> --- a/tools/lib/traceevent/parse-filter.c
> >> +++ b/tools/lib/traceevent/parse-filter.c
> >> @@ -583,12 +583,18 @@ static int add_right(struct filter_arg *op, struct filter_arg *arg,
> >>                         op->str.type = op_type;
> >>                         op->str.field = left->field.field;
> >>                         op->str.val = strdup(str);
> >> -                       if (!op->str.val)
> >> -                               die("malloc string");
> >> +                       if (!op->str.val) {
> >> +                               show_error(error_str, "Failed to allocate string filter");
> >> +                               return -1;
> >> +                       }
> >>                         /*
> >>                          * Need a buffer to copy data for tests
> >>                          */
> >> -                       op->str.buffer = malloc_or_die(op->str.field->size + 1);
> >> +                       op->str.buffer = malloc(op->str.field->size + 1);
> >> +                       if (op->str.buffer) {
> >
> > That should probably be
> >
> > if (!op->str.buffer)
> 
> Argh.. you're right!

I was thinking that it was better to do it Namhyung's way, with:

	if (op->str.buffer == NULL)

than my preferred way of:

	if (!op->str.buffer)

because I thought this mistake is more prevalent with my way. But It's
good to know that this bug happens regardless of which way you
prefer ;-)

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab3LIG7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 01:59:30 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49121 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760356Ab3LIG73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 01:59:29 -0500
X-AuditID: 9c930179-b7ce4ae000000e86-db-52a56a4e3c65
From: Namhyung Kim <namhyung@kernel.org>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 09/14] tools lib traceevent: Get rid of die() in add_right()
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-10-git-send-email-namhyung@kernel.org>
	<CAKb7Uvhhg2siBURLxTb2jgW_-5AUeK_yqRpEJgi0HW12zQTMyg@mail.gmail.com>
Date: Mon, 09 Dec 2013 15:59:26 +0900
In-Reply-To: <CAKb7Uvhhg2siBURLxTb2jgW_-5AUeK_yqRpEJgi0HW12zQTMyg@mail.gmail.com>
	(Ilia Mirkin's message of "Mon, 9 Dec 2013 01:28:26 -0500")
Message-ID: <87fvq2mrw1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ilia,

On Mon, 9 Dec 2013 01:28:26 -0500, Ilia Mirkin wrote:
> On Mon, Dec 9, 2013 at 12:34 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/lib/traceevent/parse-filter.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
>> index 5efe66a682bd..a1ad609a860f 100644
>> --- a/tools/lib/traceevent/parse-filter.c
>> +++ b/tools/lib/traceevent/parse-filter.c
>> @@ -583,12 +583,18 @@ static int add_right(struct filter_arg *op, struct filter_arg *arg,
>>                         op->str.type = op_type;
>>                         op->str.field = left->field.field;
>>                         op->str.val = strdup(str);
>> -                       if (!op->str.val)
>> -                               die("malloc string");
>> +                       if (!op->str.val) {
>> +                               show_error(error_str, "Failed to allocate string filter");
>> +                               return -1;
>> +                       }
>>                         /*
>>                          * Need a buffer to copy data for tests
>>                          */
>> -                       op->str.buffer = malloc_or_die(op->str.field->size + 1);
>> +                       op->str.buffer = malloc(op->str.field->size + 1);
>> +                       if (op->str.buffer) {
>
> That should probably be
>
> if (!op->str.buffer)

Argh.. you're right!

>
> Also, should you free op->str.val? Perhaps the surrounding code takes
> care of that.

Yeah, it'll be handled by the caller - process_filter().

Thanks for the quick review!
Namhyung

>
>> +                               show_error(error_str, "Failed to allocate string filter");
>> +                               return -1;
>> +                       }
>>                         /* Null terminate this buffer */
>>                         op->str.buffer[op->str.field->size] = 0;
>>
>> --
>> 1.7.11.7
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

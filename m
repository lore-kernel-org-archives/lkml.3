Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab3LDNL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:11:59 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48924 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab3LDNL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:11:58 -0500
MIME-Version: 1.0
In-Reply-To: <20131204125904.GB6359@ghostprotocols.net>
References: <1385732192-27713-1-git-send-email-artagnon@gmail.com>
 <1385732192-27713-3-git-send-email-artagnon@gmail.com> <20131201195634.GB1215@krava.brq.redhat.com>
 <20131202193502.GA3706@infradead.org> <CALkWK0nBDqHSWxCVYtU5NMZ4J4=DHGXqk0ZHzM2z8rS1ohjwRw@mail.gmail.com>
 <20131204125904.GB6359@ghostprotocols.net>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 4 Dec 2013 18:41:18 +0530
Message-ID: <CALkWK0m_W0c7AhCOZmMObq2MUjL83jL+YsM-qUmXz8j0MOFLiw@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] perf diff: color the Ratio column
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
>> The issue with this suggestion is that the prototype of
>> percent_color_snprintf() is:
>>
>>   int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...)
>>
>> So, I can only pass value_color_snprintf() a va_list, making its prototype:
>>
>>   int value_color_snprintf(char *bf, size_t size, const char *fmt, va_list args)
>>
>> Is this worth the minor rename?
>
> That is ok, I'd say. Or if that would be a problem one could consider
> using a macro, perhaps.

If value_color_snprintf has the prototype mentioned above, I'd have to
build a va_list at each callsite; how is that convenient? Considering
the macro, can we just do

  #define percent_color_snprintf value_color_snprintf

in color.h?

>> On a related note, does percent_color_snprintf() need to be a variadic
>> function? It only seems to process one percent value.
>
> I think that there are places where it is passed as a pointer that
> expects it to have that prototype, this is from memory, so please check.

I meant that the function body itself seems to be wrong:

  va_start(args, fmt);
  percent = va_arg(args, double);
  va_end(args);
  color = get_percent_color(percent);
  return color_snprintf(bf, size, color, fmt, percent);

Unless I've misunderstood something horribly, doesn't `percent' just
get assigned to the last argument in the `args' va_list?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3KLPZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:25:09 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59153 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab3KLPZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:25:06 -0500
Message-ID: <5282484E.9010206@gmail.com>
Date: Tue, 12 Nov 2013 08:25:02 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: Delete file if a failure occurs writing
 the perf data file
References: <1383928906-31470-1-git-send-email-dsahern@gmail.com> <20131111093747.GA14810@gmail.com> <5280ECFF.10103@gmail.com> <52824064.4060100@gmail.com> <20131112150410.GW5056@laptop.programming.kicks-ass.net>
In-Reply-To: <20131112150410.GW5056@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13, 8:04 AM, Peter Zijlstra wrote:
> On Tue, Nov 12, 2013 at 07:51:16AM -0700, David Ahern wrote:
>>>  From man mmap:
>>>         SIGBUS Attempted access to a portion of the buffer that
>>>         does not correspond  to  the  file (for  example, beyond
>>>         the end of the file, ...
>
> SIGBUS is basically the std fail for any fault; there's a ton more
> reasons than listed in that manpage.
>
> Failing to dirty a page due to -ENOSPACE is one reason we'll
> trigger SIGBUS -- as you already found in that memcpy to mmap() instead
> of write() patch.

Sure. Lots of mmaps flying around, so to make sure we are on the same 
page in this case we are talking about perf-report reading a file via mmap.

If the file creation (be it memcpy to mmap() or write()) has a failure 
due to lack of space, then only a partial event is in the file -- e.g., 
perf-header only. Trying to read the rest of the event leads to 
perf-report terminating due to SIGBUS. How should that condition be handled?

The patch in this thread deletes the file. Another option is to rewind 
the file to the last known good write (ie., length after last successful 
call to write_output).

David


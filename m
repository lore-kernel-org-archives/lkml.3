Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaBXFXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:23:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58429 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbaBXFXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:23:22 -0500
Message-ID: <530AD71E.50800@zytor.com>
Date: Sun, 23 Feb 2014 21:22:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vince Weaver <vincent.weaver@maine.edu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
References: <alpine.DEB.2.10.1402211521040.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211732290.11615@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402212342090.17416@vincent-weaver-1.um.maine.edu> <53084317.4090304@zytor.com> <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu> <e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com> <alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu>
In-Reply-To: <alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2014 07:02 PM, Vince Weaver wrote:
> On Sun, 23 Feb 2014, Vince Weaver wrote:
>>
>> and as far as I can tell nothing touches rbp again until the segfault.
>> Nothing in _memset_sse2 does as far as I can tell.
> 
> I only know enough about ftrace to be dangerous, but here is what I think 
> is the trace of the problem:
> 
>      perf_fuzzer-11492 [000] 197077.488420: function:                perf_output_put_handle
>      perf_fuzzer-11492 [000] 197077.488421: function:             __do_page_fault

So we do a write to the buffer rather immediately before this happens,
and in particular that will update the head:

	rb->user_page->data_head = head;

However, that doesn't explain what is going on and in particular the
write to whatever address was in %rbp.  The rest pretty much seems to be
the page fault logic.

Incidentally, I doubt that this is x32-related in any way; there seems
to be absolutely no difference between x86-64 perf and x32 perf; more
likely it just makes the error more reproducible because the address
space is so much smaller.

	-hpa



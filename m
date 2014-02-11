Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaBKCQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 21:16:14 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:44572 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752180AbaBKCQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:16:11 -0500
Message-ID: <52F987CE.7010300@hurleysoftware.com>
Date: Mon, 10 Feb 2014 21:15:42 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
CC: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Eric Dumazet <edumazet@google.com>
Subject: Re: [BUG] perf top: --stdio causes continuous refresh
References: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com> <20140206135627.GA26955@infradead.org> <CABPqkBS5qLDYyyv=n8fT4K+hA3uRWYmQOZmO+n-UE9=X=cEFzQ@mail.gmail.com> <20140206140705.GB26955@infradead.org> <20140206140936.GC26955@infradead.org> <CABPqkBRwy=0pnmm657TwV25GiYbpkqC1E8+cUGLEUbqxO=Gusw@mail.gmail.com> <52F3CAE3.7060007@gmail.com> <20140210210358.GD3202@infradead.org>
In-Reply-To: <20140210210358.GD3202@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On 02/10/2014 04:03 PM, Arnaldo Carvalho de Melo wrote:
> Em Thu, Feb 06, 2014 at 10:48:19AM -0700, David Ahern escreveu:
>> On 2/6/14, 8:24 AM, Stephane Eranian wrote:
>>> On Thu, Feb 6, 2014 at 3:09 PM, Arnaldo Carvalho de Melo
>>> <acme@redhat.com> wrote:
>>>> Em Thu, Feb 06, 2014 at 12:07:05PM -0200, Arnaldo Carvalho de Melo escreveu:
>>>>> Em Thu, Feb 06, 2014 at 02:58:01PM +0100, Stephane Eranian escreveu:
>>>>>> On Thu, Feb 6, 2014 at 2:56 PM, Arnaldo Carvalho de Melo
>>>>>> <acme@redhat.com> wrote:
>>>>>>> Em Wed, Feb 05, 2014 at 10:25:09PM +0100, Stephane Eranian escreveu:
>>>>>>>> If you run perf top on 3.14 but you force --stdio mode, perf top
>>>>>>>> goes crazy and constantly refreshes the output.
>
>>>>>>>> It does that with many older versions of the perf as well on 3.14.
>>>>>>>> It runs fine with newt mode.
>
>>>>>>>> Works fine with my 3.11 kernel. So something must be broken
>>>>>>>> with 3.14.
>
>>>>>>>> Can you reproduce the problem as well?
>
>>>>>>> Not so far, using my perf/urgent branch:
>
>>>>>> I am using tip.git. Or try 3.11, 3.10.
>
>>>> But my tests are on top of:
>
>>>> [acme@ssdandy linux]$ uname -r
>>>> 3.11.4-101.fc18.x86_64
>
>>>> I thought it was a 3.14ish one, building one to try there...
>>>>
>>> The kernel must be 3.14-rcX, the tool can be any version.
>>
>> I don't have time to do a git bisect, but I can narrow the window to
>> 3.13-rc6 and 3.14-rc1. Just happened to update a server yesterday.
>> perf-top --stdio runs fine on the former and shows the problem on
>> the latter.
>
> Bisected it down to:
>
> eb3e4668bd9e0bbda592e830e889f137e44ec9e4 is the first bad commit
> commit eb3e4668bd9e0bbda592e830e889f137e44ec9e4
> Author: Peter Hurley <peter@hurleysoftware.com>
> Date:   Mon Dec 2 14:24:42 2013 -0500
>
>      n_tty: Un-inline slow-path n_tty_receive_char()
>
>      Commit e60d27c4d8b33ba20896b76b6558f061bc6460ff,
>      n_tty: Factor LNEXT processing from per-char i/o path,
>      mistakenly inlined the non-inline alias, n_tty_receive_char(),
>      for the inline function, n_tty_receive_char_inline().
>
>      As n_tty_receive_char() is intended for slow-path char
>      processing only, un-inline it.
>
>      Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>      Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> :040000 040000 80215819e331ff95d80aa7c8a6a05f8c74d1fdb6 41a856dfeb6769e47c7689c92d91db497dfcc8cf M	drivers
> [acme@fedora20 linux]$
>
> In a hurry now, will continue later, trying to understand what is the problem
> introduced by the above cset...
>
> Need to revert just this one to confirm that it is the culprit, etc.

Thanks for the report and bisect. Seems unlikely this commit is the
cause, but very likely to be some change I made since 3.13, since
I can repro on 3.14-rc1 but not on 3.13.2 -stable. I can also repro
this on 3.12 + the patch stack from me for 3.13 and 3.14.

I'm looking into this now.

Regards,
Peter Hurley

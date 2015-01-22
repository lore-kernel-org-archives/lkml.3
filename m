Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbbAVUMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:12:35 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:48439 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbbAVUMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:12:33 -0500
MIME-Version: 1.0
In-Reply-To: <20150122194746.GB4634@pd.tnic>
References: <cover.1421954363.git.luto@amacapital.net> <0cb251abe1ff0958b8e468a9a9a905b80ae3a746.1421954363.git.luto@amacapital.net>
 <20150122194746.GB4634@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Jan 2015 12:12:11 -0800
Message-ID: <CALCETrU55UUe_cJf3Vx-ybYQsH-du0PyH234Q4PzbUTjXHrRjw@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86, tls: Interpret an all-zero struct user_desc as
 "no segment"
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend -- thanks, gmail]

On Thu, Jan 22, 2015 at 11:47 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jan 22, 2015 at 11:27:59AM -0800, Andy Lutomirski wrote:
>> The Witcher 2 did something like this to allocate a TLS segment index:
>>
>>         struct user_desc u_info;
>>         bzero(&u_info, sizeof(u_info));
>>         u_info.entry_number = (uint32_t)-1;
>>
>>         syscall(SYS_set_thread_area, &u_info);
>>
>> Strictly speaking, this code was never correct.  It should have set
>> read_exec_only and seg_not_present to 1 to indicate that it wanted
>> to find a free slot without putting anything there, or it should
>> have put something sensible in the TLS slot if it wanted to allocate
>> a TLS entry for real.  The actual effect of this code was to
>> allocate a bogus segment that could be used to exploit espfix.
>>
>> The set_thread_area hardening patches changed the behavior, causing
>> set_thread_area to return -EINVAL and crashing the game.
>>
>> This changes set_thread_area to interpret this as a request to find
>> a free slot and to leave it empty, which isn't *quite* what the game
>> expects but should be close enough to keep it working.  In
>> particular, using the code above to allocate two segments will
>> allocate the same segment both times.
>>
>> According to FrostbittenKing on Github, this fixes The Witcher 2.
>>
>> If this somehow still causes problems, we could instead allocate
>> a limit==0 32-bit data segment, but that seems rather ugly to me.
>>
>> Fixes: 41bdc78544b8 x86/tls: Validate TLS entries to protect espfix
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>
> Shouldn't this also be CC:stable?
>

Yes.

Ingo, Thomas, or Linus, if you apply this version, can you add that?

--Andy

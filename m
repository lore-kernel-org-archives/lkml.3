Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbbA2CtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:49:16 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:46794 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbbA2CtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:49:11 -0500
Message-ID: <54C91C5A.400@android.com>
Date: Wed, 28 Jan 2015 09:28:58 -0800
From: Mark Salyzyn <salyzyn@android.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: =?UTF-8?B?xYF1a2FzeiBTdGVsbWFjaA==?= <stlman@poczta.fm>
CC: linux-kernel@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        =?UTF-8?B?IkJhcnTFgm9taWVqIMW7b8WCbmllcmtpZXdpY3ogc3RsbWFuQHBvY3p0YS5mbSI=?= 
	<b.zolnierkie@samsung.com>
Subject: Re: [PATCH v4 4/5] pstore: add pmsg
References: <1421194580-20230-1-git-send-email-salyzyn@android.com> <871tmfz06r.fsf%stlman@poczta.fm>
In-Reply-To: <871tmfz06r.fsf%stlman@poczta.fm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 04:16 PM, Łukasz Stelmach wrote:
>> A secured user-space accessible pstore object. Writes
>> to /dev/pmsg0 are appended to the buffer, on reboot
>> the persistent contents are available in
>> /sys/fs/pstore/pmsg-ramoops-[ID].
>>
>> One possible use is syslogd, or other daemon, can
>> write messages, then on reboot provides a means to
>> triage user-space activities leading up to a panic
>> as a companion to the pstore dmesg or console logs.
>>
>> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
>> ---
> I am not an expert but this smells like duplicating /dev/kmsg. If
> I remember correctly since about Linux 3.5 /dev/kmsg is writable for the
> user-space and every single process (modulo MAC/DAC) can log there. The
> messages from user-space are preserved accross reboots as a part of the
> kmsg/printk buffer anyway.
>
> What is the advantege of pmsg0 over /dev/kmsg?

- Precious little user-space content goes to kmsg (otherwise you can ask 
why is there a syslogd?), there is a reason for this, user space is 
notorious for containing Personal Identifiable Information whereas 
kernel information does not.
- pmsg0 can take a lot of content (with a ramoops backend) and will not 
disrupt/DOS the kernel logs.
- State, Binary or packetized content can go to /dev/pmsg0 and not 
interfere with the text content in kmsg
- /dev/pmsg0 write is atomic
- /dev/pmsg0 is write only, there is no access to the live content 
_unless_ there is a reboot.
- Personal identification which abounds in user space could be placed 
into /dev/pmsg0, and there is no way except a reboot in order to extract 
the content, and then /sys/fs/pstore/pmsg-ramoops-0 can be deleted, or 
heavily MAC and DAC controlled to enforce protection (doing so to kmsg 
would be unlivable)

Sincerely -- Mark Salyzyn

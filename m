Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3DVVHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:07:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3DVVHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:07:48 -0400
Message-ID: <5175A697.3080308@dawncrow.de>
Date: Mon, 22 Apr 2013 23:07:35 +0200
From: =?ISO-8859-1?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv2] arm: Preserve TPIDRURW on context switch
References: <517168BB.3070903@dawncrow.de> <20130422143616.GP14496@n2100.arm.linux.org.uk> <20130422151836.GA15665@mudshark.cambridge.arm.com>
In-Reply-To: <20130422151836.GA15665@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:8bvTqSKq8QLReRkzDrpKdXpzJMwoHw6AQSlANfz9wTi
 IcgPhvCCeWD2r/tJSPvmOvJI0176BuxHq+ThLamFdqdLSp32x/
 7NVSI1SOgYFcm+mfVPR73bzYpjk7yNh6unHCGL378hlezppNVj
 tuQMgwzbu4u/u1LTbbMAjchN9WPdA//kLbxrVNWUoCDu0wQMJQ
 ZDSmv/YrASDO2MkQTb2pfLCRlfZpjrZZSWFHa8T3jdRP3q9/JO
 QVC7pk8/a3g9Xg/BcRU/oBmHgDbVjVye2y5SS7NbP9OLTusbFc
 GVV3tIL1lNukUKCBzIhEUHebjkttrzQ9zPMG1CeGpz/87nt4Bw
 51Nw1oKtvuOpASioj4h4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.04.2013 17:18, schrieb Will Deacon:
> On Mon, Apr 22, 2013 at 03:36:16PM +0100, Russell King - ARM Linux wrote:
>> On Fri, Apr 19, 2013 at 05:54:35PM +0200, André Hentschel wrote:
>>> From: =?UTF-8?q?Andr=C3=A9=20Hentschel?= <nerv@dawncrow.de>
>>>
>>> There are more and more applications coming to WinRT, Wine could support them,
>>> but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
>>> This register must be preserved per thread instead of being cleared.
>>>
>>> Signed-off-by: André Hentschel <nerv@dawncrow.de>
>>
>> This actually makes things less efficient all round, because you
>> now use the value immediately after loading, which means it will cause
>> pipeline stalls, certainly on older CPUs.
>>
>> Could you please rework the patch to try avoiding soo many modifications
>> to the way things have been done here?
> 
> copy_thread also needs updating so that the *register* value for the parent
> is copied to the child, since the parent may have written the register
> after the last context-switch, meaning that tp_value is out-of-date.

Thank you both for reviewing.

I guess you mostly mean "ldr	r6, [r2, #TI_CPU_DOMAIN]".
I just thought about old CPUs and remembered again that we at Wine
need that patch only on v7 (and later). So is it ok to introduce a set_tls_v7
in tls.h and make use of CONFIG_CPU_V7 compile-time check in
the changed files and in the copy_thread function?
Do i need any further flag checks in copy_thread or can i use the
compile-time check to add unconditional code?


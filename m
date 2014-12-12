Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966536AbaLLLfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:35:20 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36365 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966072AbaLLLfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:35:17 -0500
Message-ID: <548AD2F1.3080200@konagma.com>
Date: Fri, 12 Dec 2014 12:35:13 +0100
From: Krzysztof Konopko <kris@konagma.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
References: <1418336609-10191-1-git-send-email-kris@konagma.com> <548A2E7A.4010303@lwfinger.net>
In-Reply-To: <548A2E7A.4010303@lwfinger.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/14 00:53, Larry Finger wrote:
> On 12/11/2014 04:23 PM, Krzysztof Konopko wrote:
>> Some struct fields in wifi.h are meant to be __le16 bu were declared as
>> unsigned short.  This was reported by sparse:
>>
>>    rtw_wlan_util.c:538:24: warning: cast to restricted __le16
>>    rtw_wlan_util.c:1544:29: warning: cast to restricted __le16
>>    rtw_wlan_util.c:1546:25: warning: cast to restricted __le16
>>
>> This patch changes declared types of the struct fields involved.
>>
>> Signed-off-by: Krzysztof Konopko <kris@konagma.com>
>> ---
>>   drivers/staging/rtl8723au/include/wifi.h | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8723au/include/wifi.h
>> b/drivers/staging/rtl8723au/include/wifi.h
>> index fd3da3b..8a2adc5 100644
>> --- a/drivers/staging/rtl8723au/include/wifi.h
>> +++ b/drivers/staging/rtl8723au/include/wifi.h
>> @@ -28,7 +28,7 @@
>>   struct AC_param {
>>       unsigned char        ACI_AIFSN;
>>       unsigned char        CW;
>> -    unsigned short    TXOP_limit;
>> +    __le16            TXOP_limit;
>>   }  __packed;
>>
>>   struct WMM_para_element {
>> @@ -39,9 +39,9 @@ struct WMM_para_element {
>>
>>   struct ADDBA_request {
>>       unsigned char        dialog_token;
>> -    unsigned short    BA_para_set;
>> +    __le16        BA_para_set;
>>       unsigned short    BA_timeout_value;
>> -    unsigned short    BA_starting_seqctrl;
>> +    __le16        BA_starting_seqctrl;
>>   }  __packed;
> 
> This fix may make the sparse warnings go away, but I think it introduces
> new bugs.

Right, I see.  Nice try though, isn't it? ;)

> In particular, did you test on big-endian hardware after you
> made this change?

Nope.  I don't have any big-endian hardware.  I don't even have the
wireless card TBH.  But I'm happy to try to get one.  Is Rtl8723AE the
right model?

> I recently found that the driver for RTL8188EU needed
> to have BA_para_set to unsigned short, and the endianess warnings needed
> to be fixed in the code. Then it would work on my PowerBook G4 with a
> PPC processor.
> 

OK.  Does it still work with little endian?

> In RTL8188EU, both BA_starting_seqctrl and TXOP_limit are unsigned short.
> 

That's not quite the case.  `TXOP_limit` is __le16 in RTL8188EU [1].
It's __le16 even in your GitHub repo [2].  And that made me thinking
that there's probably some inconsistency in the header.

I'm _far_ from being a wireless expert but doesn't data coming out of
the wire/air have the endianess defined explicitly?  And both `AC_param`
and `ADDBA_request` come out of air?

I was hunting particularly for inconsistencies with `sparse` and came
across this one.  But I dug a bit further and I wonder why the driver is
not using standard stuff like the one in `include/linux/ieee80211.h`
where any data wider than one byte is clearly declared as __le<nn>?

Cheers,
Kris

--

[1] drivers/staging/rtl8188eu/include/wifi.h as of next-20141211
[2] https://github.com/lwfinger/rtl8188eu/blob/master/include/wifi.h

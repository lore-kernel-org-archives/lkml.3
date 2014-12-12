Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaLLWaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:30:30 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:41852 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaLLWa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:30:28 -0500
Message-ID: <548B6C80.5020607@konagma.com>
Date: Fri, 12 Dec 2014 23:30:24 +0100
From: Krzysztof Konopko <kris@konagma.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: Jes Sorensen <Jes.Sorensen@redhat.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
References: <1418336609-10191-1-git-send-email-kris@konagma.com> <548A2E7A.4010303@lwfinger.net> <20141212125255.GB4921@mwanda> <548B1B18.6050307@lwfinger.net>
In-Reply-To: <548B1B18.6050307@lwfinger.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/14 17:43, Larry Finger wrote:
> On 12/12/2014 06:52 AM, Dan Carpenter wrote:
>> On Thu, Dec 11, 2014 at 05:53:30PM -0600, Larry Finger wrote:
>>> On 12/11/2014 04:23 PM, Krzysztof Konopko wrote:
>>>> Some struct fields in wifi.h are meant to be __le16 bu were declared as
>>>> unsigned short.  This was reported by sparse:
>>>>
>>>>    rtw_wlan_util.c:538:24: warning: cast to restricted __le16
>>>>    rtw_wlan_util.c:1544:29: warning: cast to restricted __le16
>>>>    rtw_wlan_util.c:1546:25: warning: cast to restricted __le16
>>>>
>>>> This patch changes declared types of the struct fields involved.
>>>>
>>>> Signed-off-by: Krzysztof Konopko <kris@konagma.com>
>>>> ---
>>>>   drivers/staging/rtl8723au/include/wifi.h | 6 +++---
>>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/rtl8723au/include/wifi.h
>>>> b/drivers/staging/rtl8723au/include/wifi.h
>>>> index fd3da3b..8a2adc5 100644
>>>> --- a/drivers/staging/rtl8723au/include/wifi.h
>>>> +++ b/drivers/staging/rtl8723au/include/wifi.h
>>>> @@ -28,7 +28,7 @@
>>>>   struct AC_param {
>>>>       unsigned char        ACI_AIFSN;
>>>>       unsigned char        CW;
>>>> -    unsigned short    TXOP_limit;
>>>> +    __le16            TXOP_limit;
>>>>   }  __packed;
>>>>
>>>>   struct WMM_para_element {
>>>> @@ -39,9 +39,9 @@ struct WMM_para_element {
>>>>
>>>>   struct ADDBA_request {
>>>>       unsigned char        dialog_token;
>>>> -    unsigned short    BA_para_set;
>>>> +    __le16        BA_para_set;
>>>>       unsigned short    BA_timeout_value;
>>>> -    unsigned short    BA_starting_seqctrl;
>>>> +    __le16        BA_starting_seqctrl;
>>>>   }  __packed;
>>>
>>> This fix may make the sparse warnings go away, but I think it
>>> introduces new bugs.
>>
>> This kind of change, doesn't change the compiled code only how Sparse
>> sees it.  It can't introduce bugs.
>>
>> But it may well be that the calls to le16_to_cpu() should be removed.  I
>> looked at it a bit but I don't know.
> 
> Your point regarding bugs is taken. What I should have said is that
> blindly making _le changes to hide Sparse messages may hide existing
> bugs for BE hardware.
> 
> Larry
> 
> 

Yes, I started it off blindly but dug further and now have a better
understanding.  Looking in ieee80211.h and getting your feedback helped
me to get a better understanding of the situation.

I see nothing wrong in declaring data that is supposed to be
little-endian as __le.  You say that making these changes blindly may
hide existing bugs but:

* not doing anything about it is not helpful either

* this is no longer changing anything blindly
Relevant structs: `addba_req` and `ieee80211_wmm_ac_param` do declare
their fields as __le where needed.

I do take a point though about making this change inconsistently
(blindly) in my initial patch.

Kris

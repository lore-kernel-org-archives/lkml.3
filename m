Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbbAMPzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:55:48 -0500
Received: from mail-db3on0068.outbound.protection.outlook.com ([157.55.234.68]:7403
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752603AbbAMPzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:55:46 -0500
Message-ID: <54B53FEE.2090903@ezchip.com>
Date: Tue, 13 Jan 2015 10:55:26 -0500
From: Chris Metcalf <cmetcalf@ezchip.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2 23/40] tile: enable sparse checks for get/put_user
References: <1420558883-10131-1-git-send-email-mst@redhat.com> <1420558883-10131-24-git-send-email-mst@redhat.com> <54B46204.1010003@ezchip.com> <20150113094554.GB4434@redhat.com>
In-Reply-To: <20150113094554.GB4434@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [12.216.194.146]
X-ClientProxiedBy: BLUPR07CA0105.namprd07.prod.outlook.com (10.255.223.176) To
 AM3PR02MB0534.eurprd02.prod.outlook.com (25.160.6.140)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=cmetcalf@ezchip.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:AM3PR02MB0534;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:AM3PR02MB0534;
X-Forefront-PRVS: 045584D28C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(189002)(51704005)(199003)(377454003)(24454002)(479174004)(86362001)(93886004)(54356999)(87266999)(101416001)(65816999)(50986999)(83506001)(110136001)(105586002)(76176999)(19580395003)(33656002)(65956001)(46102003)(106356001)(47776003)(64706001)(23746002)(42186005)(65806001)(66066001)(40100003)(122386002)(62966003)(77156002)(64126003)(68736005)(36756003)(77096005)(59896002)(97736003)(80316001)(50466002)(2950100001)(92566002)(15975445007)(18886065003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM3PR02MB0534;H:[10.7.0.239];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:AM3PR02MB0534;
X-OriginatorOrg: ezchip.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2015 15:55:43.1538 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM3PR02MB0534
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/13/2015 4:45 AM, Michael S. Tsirkin wrote:
> On Mon, Jan 12, 2015 at 07:08:36PM -0500, Chris Metcalf wrote:
>> The key changes are to copy the x86 definition of __inttype(), and then to
>> arrange to use an intermediate integral type that gets assigned to or from
>> the actual typed value so as to expose any sparse issues.
>>
>> If this works for you, I'm happy to queue it in the tile tree, or I can
>> provide a proper git commit for you to include in your series, whichever
>> works better for you.
> Please queue it up for 3.20. Extra __force is needed in a couple of
> places - would you like to fix this up yourself, or do you want me to
> write a patch on top?

I'll fold in your suggestions to my patch.

>> @@ -178,7 +178,7 @@ extern int fixup_exception(struct pt_regs *regs);
>>                               "9:"                                       \
>>                               : "=r" (ret), "=r" (__a), "=&r" (__b)      \
>>                               : "r" (ptr), "i" (-EFAULT));               \
>> -               (x) = (__typeof(x))(__typeof((x)-(x)))                  \
>> +               (x) = (__typeof(x))(__inttype(x))                       \
>>                          (((u64)__hi32(__a, __b) << 32) |                \
>>                           __lo32(__a, __b));                             \
>>          })
> This cast to __typeof(x) needs to be done with __force, otherwise
> there will be a warning with bitwise types.

Actually, this place no longer needs any casting at all, on reflection.
I've changed the __get_user() code to do the "get" into an __inttype
uniformly, so __get_user_8 will always have a u64 type for "x" here.

I'll cc you on the updated patch, so if you'd like to add your
Reviewed-by tag to it, let me know.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com


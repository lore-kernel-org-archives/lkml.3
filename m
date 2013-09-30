Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3I3RbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:31:14 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:37192
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755800Ab3I3RbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:31:11 -0400
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Sep 2013 13:31:11 EDT
From: "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>
To: David Daney <ddaney.cavm@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>,
        Markos Chandras <Markos.Chandras@imgtec.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>,
        John Crispin <blogic@openwrt.org>
Subject: Re: Issue with BUG() in asm-gemeric/bug.h if CONFIG_BUG=n
Thread-Topic: Issue with BUG() in asm-gemeric/bug.h if CONFIG_BUG=n
Thread-Index: AQHOve9zbNvbRHb/BEuMPyjMocyqfJnebqCAgAAW8Wo=
Date: Mon, 30 Sep 2013 17:15:53 +0000
Message-ID: <C9BC92C2-A7F5-4F9A-B001-D1A7F4ADEA5A@caviumnetworks.com>
References: <20130930145630.GA14672@linux-mips.org>,<52499E8B.6000702@gmail.com>
In-Reply-To: <52499E8B.6000702@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [75.94.143.192]
x-forefront-prvs: 0985DA2459
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(164054003)(189002)(199002)(51704005)(479174003)(377454003)(80976001)(36756003)(81542001)(56816003)(76482001)(76786001)(76796001)(81816001)(19580395003)(81342001)(83322001)(19580405001)(54356001)(56776001)(54316002)(69226001)(79102001)(53806001)(63696002)(81686001)(74366001)(4396001)(51856001)(31966008)(50986001)(49866001)(33656001)(47976001)(66066001)(80022001)(65816001)(74876001)(47446002)(74662001)(74502001)(83072001)(77096001)(47736001)(74706001)(77982001)(59766001)(82746002)(46102001)(83716002);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR07MB128;H:CO1PR07MB127.namprd07.prod.outlook.com;CLIP:75.94.143.192;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sep 30, 2013, at 9:20 AM, "David Daney" <ddaney.cavm@gmail.com> wrote:

> 
>> On 09/30/2013 07:56 AM, Ralf Baechle wrote:
>> Lately I received several patches for build issues that only strike if
>> CONFIG_BUG is disabled.  Here's a test case extracted from one of them:
>> 
>> /*
>>  * Definition of BUG taken from asm-generic/bug.h for the CONFIG_BUG=n case
>>  */
>> #define BUG()    do {} while(0)
>> 
>> int foo(int arg)
>> {
>>    int res;
>> 
>>    if (arg == 1)
>>        res = 23;
>>    else if (arg == 2)
>>        res = 42;
>>    else
>>        BUG();
>> 
>>    return res;
>> }
>> 
>> [ralf@h7 ~]$ gcc -O2 -Wall -c bug.c
>> bug.c: In function ‘foo’:
>> bug.c:17:2: warning: ‘res’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>>   return res;
>>   ^
>> 
>> It's fairly obvious to see what's happening here - GCC doesn't know that
>> the else case can not be reached, thus razorsharply concludes that res
>> may be used uninitialized.
>> 
>> There several locations where MIPS - possibly other architectures as well -
>> is affected by this.
>> 
>> I think the definition of BUG should be changed to something like
>> 
>> #define BUG()    unreachable()
>> 16304
>> unreachable() will depending on the compiler being used, expand either
>> into a call to __builtin_unreachable() or where that function is
>> unavailable, into do {} while (1).
> 
> The *only* reason we have CONFIG_BUG=n is to reduce code size.
> 
> Sticking in that empty loop, negates the entire point.
> 
> IMHO: We should do one of:
> o Make CONFIG_BUG=y mandatory
> o Ignore the warnings.
> o Fix the warning sites so they quit Warning.
> 
> So I don't think the patch is really an improvement over the status quo.

What about using __builtin_unreachable when we can but turn off warnings and use do{}while(0) when __builtin_unreachable does not exist?  This seems the both worlds.  Newer compilers produce better code with unreachable anyways.

Thanks,
Andrew


> 
> David Daney
>> 
>> __builtin_unreachable() was introduce for GCC 4.5.0.
>> 
>> This means there'd be minor bloat for antique compilers - but probably
>> even better code generation for compilers supporting __builtin_unreachable().
>> 
>>   Ralf
>> 
>> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
>> 
>>  include/asm-generic/bug.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
>> index 7d10f96..6f78771 100644
>> --- a/include/asm-generic/bug.h
>> +++ b/include/asm-generic/bug.h
>> @@ -108,7 +108,7 @@ extern void warn_slowpath_null(const char *file, const int line);
>> 
>>  #else /* !CONFIG_BUG */
>>  #ifndef HAVE_ARCH_BUG
>> -#define BUG() do {} while(0)
>> +#define BUG() unreachable()
>>  #endif
>> 
>>  #ifndef HAVE_ARCH_BUG_ON
>> 
>> ----- End forwarded message -----
>> 
>>   Ralf
> 
> 

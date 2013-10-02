Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3JBAsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 20:48:18 -0400
Received: from blu0-omc1-s31.blu0.hotmail.com ([65.55.116.42]:28913 "EHLO
	blu0-omc1-s31.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559Ab3JBAsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 20:48:14 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Oct 2013 20:48:14 EDT
X-TMN: [94OeEBxB3WPVlOIYHSl/iqjoFoAY8ClN]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP20819B96B27461E7D1BD6997160@phx.gbl>
CC: Helge Deller <deller@gmx.de>, Tejun Heo <tj@kernel.org>,
        Libin <huawei.libin@huawei.com>, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org
From: John David Anglin <dave.anglin@bell.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1380667842.2081.33.camel@dabdike>
Content-Type: multipart/mixed; boundary="Apple-Mail-4-787863263"
Subject: Re: [PATCH] [workqueue] check values of pwq and wq in print_worker_info() before use
MIME-Version: 1.0 (Apple Message framework v936)
Date: Tue, 1 Oct 2013 20:41:45 -0400
References: <20131001203520.GA8248@p100.box> <20131001204352.GA27149@mtj.dyndns.org> <1380663645.2081.29.camel@dabdike> <524B47A8.1010701@gmx.de> <1380667842.2081.33.camel@dabdike>
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 02 Oct 2013 00:42:01.0950 (UTC) FILETIME=[358E87E0:01CEBF08]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail-4-787863263
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On 1-Oct-13, at 6:50 PM, James Bottomley wrote:

> On Wed, 2013-10-02 at 00:07 +0200, Helge Deller wrote:
>> On 10/01/2013 11:40 PM, James Bottomley wrote:
>>> On Tue, 2013-10-01 at 16:43 -0400, Tejun Heo wrote:
>>>> Hello,
>>>>
>>>> On Tue, Oct 01, 2013 at 10:35:20PM +0200, Helge Deller wrote:
>>>>> print_worker_info() includes no validity check on the pwq and wq
>>>>> pointers before handing them over to the probe_kernel_read()  
>>>>> functions.
>>>>>
>>>>> It seems that most architectures don't care about that, but at  
>>>>> least on
>>>>> the parisc architecture this leads to a kernel crash since  
>>>>> accesses to
>>>>> page zero are protected by the kernel for security reasons.
>>>>>
>>>>> Fix this problem by verifying the contents of pwq and wq before  
>>>>> usage.
>>>>> Even if probe_kernel_read() usually prevents such crashes by  
>>>>> disabling
>>>>> page faults, clean code should always include such checks.
>>>>>
>>>>> Without this fix issuing "echo t > /proc/sysrq-trigger" will  
>>>>> immediately
>>>>> crash the Linux kernel on the parisc architecture.
>>>>
>>>> Hmm... um had similar problem but the root cause here is that the  
>>>> arch
>>>> isn't implementing probe_kernel_read() properly.  We really have no
>>>> idea what the pointer value may be at the dump point and that's  
>>>> why we
>>>> use probe_kernel_read().  If something like the above is  
>>>> necessary for
>>>> the time being, the correct place would be the arch
>>>> probe_kernel_read() implementation.  James, would it be difficult
>>>> implement proper probe_kernel_read() on parisc?
>>>
>>> The problem seems to be that some traps bypass our exception table
>>> handling.
>>
>> Yes, that's correct.
>> It's trap #26 and we directly call parisc_terminate() for  
>> fault_space==0
>> without checking the exception table.
>> See my patch I posted a few hours ago which fixes this:
>> https://patchwork.kernel.org/patch/2971701/
>
> That doesn't quite look right ... I guessed it was probably access
> rights, so we should do an exception table fixup, so isn't this the  
> fix?
> because we shouldn't call do_page_fault if there's no exception table.

What about trap #18?  It appears the same problem can occur on PCXS.

I have the strong feeling that __copy_from_user still won't be bullet  
proof.
See attached fault.  As far as I know, we don't have an OS HPMC handler.

>
> James
>
> ---
> diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
> index 04e47c6..25a088a 100644
> --- a/arch/parisc/kernel/traps.c
> +++ b/arch/parisc/kernel/traps.c
> @@ -684,6 +684,8 @@ void notrace handle_interruption(int code,  
> struct pt_regs *regs)
> 		/* Fall Through */
> 	case 26:
> 		/* PCXL: Data memory access rights trap */
> +		if (!user_mode(regs) && fixup_exception(regs))
> +			return;
> 		fault_address = regs->ior;
> 		fault_space   = regs->isr;
> 		break;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
John David Anglin	dave.anglin@bell.net



--Apple-Mail-4-787863263
Content-Disposition: attachment; filename="hpmc-20130929.txt"
Content-Type: text/plain; x-unix-mode=0644; name="hpmc-20130929.txt"
Content-Transfer-Encoding: quoted-printable

=EF=BB=BFService Menu: Enter command > pim


PROCESSOR PIM INFORMATION

Original Product Number:  A7136A
Current Product Number:   A7136A


-----------------  Processor 0 HPMC Information - PDC Version: 46.34  =
------=20

Timestamp =3D   Sun Sep  29 14:40:29 GMT 2013    (20:13:09:29:14:40:29)

HPMC Chassis Codes

       Chassis Code        Extension
       ------------        ---------
       0xe800035c00e00000 0x0000000000000000


General Registers 0 - 31
00-03  0000000000000000  00000000406143a0  0000000000000000  =
0000000000000000
04-07  0000000000000000  0000000000000000  0000000000000000  =
0000000000000000
08-11  000000000000001a  00047dbc422040a0  0000000000000000  =
0000000000000000
12-15  0000000000000000  0000000000000000  0000000000000000  =
0000000000000000
16-19  0000000000000000  00000000ffffffff  0000000000000000  =
0000000000000000
20-23  0000000000000000  0000000000000000  0000000000000000  =
0000000000000000
24-27  000000000000d000  0000000000000000  0000000000000000  =
0000000000000000
28-31  0000000000000000  0000000000000000  160012bc00e00000  =
0000000000000000


                                                                =20
Control Registers 0 - 31
00-03  0000000000000000  0000000000000000  0000000000000000  =
0000000000000000
04-07  0000000000000000  0000000000000000  0000000000000000  =
0000000000000000
08-11  00000000000025ac  0000000000000000  00000000000000c0  =
0000000000000000
12-15  0000000000000000  0000000000000000  0000000000103000  =
ffe0000000000000
16-19  00000065514c48b9  0000000000000000  0000000000000000  =
0000000000000000
20-23  0000000000000000  0000000000000000  000000f008008200  =
0000000000000000
24-27  00000000006b4000  00000001fbc7a000  ffffffffffffffff  =
ffffffffffffffff
28-31  ffffffffffffffff  ffffffffffffffff  0000000040614000  =
a001011408940009

                                                                =20
Space Registers 0 - 7
00-03  000000000096b000  000000000096b000  0000000000000000  =
000000000096b000
04-07  0000000000000000  0000000000000000  0000000000000000  =
0000000000000000


IIA Space (back entry)       =3D 0x0000000000000000
IIA Offset (back entry)      =3D 0x0000000000000000
Check Type                   =3D 0xe0000000
Cpu State                    =3D 0x1e000000
Cache Check                  =3D 0xc0000000
TLB Check                    =3D 0x40000000
Bus Check                    =3D 0x00000000
Assists Check                =3D 0x0096b000
Assist State                 =3D 0x00000000
Path Info                    =3D 0x00000000
System Responder Address     =3D 0x0000000000000000
System Requestor Address     =3D 0x0000000000000000


                                                                =20
Floating Point Registers 0 - 31
00-03  0c15580000000000  0000000000000000  0000000000000000  =
0000000000000000
04-07  0000000a8b7ff33a  a000000000000000  0000000640000000  =
0000000000000000
08-11  0000000000000000  0000000000000000  0000000000000000  =
0000000000000000
12-15  0000000000000000  0000000000000000  0000000000000000  =
0000000000000000
16-19  0000000000000000  0000000000000000  0000000000000000  =
0000000000000000
20-23  0000000000000000  0000000000000000  0000000000000000  =
0000000000000000
24-27  0000000000000000  0000000000000000  0000000000000000  =
0000000000000000
28-31  0000000000000000  0000000000000000  0000000000000000  =
0000000000000000


PIM Revision                 =3D 0x0000000000000001               =20
CPU ID                       =3D 0x0000000000000014
CPU Revision                 =3D 0x0000000000000031
Cpu Serial Number            =3D 0x46100b89e43f0503
Check Summary                =3D 0xc0400040c2730000
SAL Timestamp                =3D 0x0000000052483bdd
System Firmware Rev.         =3D 0x00000ba20000121a
PDC Relocation Address       =3D 0xfffffff0f0c00000
Available Memory             =3D 0x00000001ffe00000
CPU Diagnose Register 2      =3D 0x311202200004200a
MIB_STAT                     =3D 0x0040000000200000
MIB_LOG1                     =3D 0x0000000000555500
MIB_LOG2                     =3D 0x0000000000000000
MIB_ECC_DATA                 =3D 0x286caf8e14000000
ICache Info                  =3D 0x0070000000000000
DCache Info                  =3D 0x0000000000000000
Sharedcache Info1            =3D 0x0000000000000000
Sharedcache Info2            =3D 0x0000000000000000
MIB_RSLOG1                   =3D 0x4930408847b60466
MIB_RSLOG2                   =3D 0x0a00010000000000
MIB_RQLOG                    =3D 0xc050408847b69400
MIB_REQLOGa                  =3D 0xa498204423db2a80
MIB_REQLOGb                  =3D 0x198280000e008000
Reserved                     =3D 0x0000000000000000
Cache Repair Detail          =3D 0x0000000000000000

PIM Detail Text:

                                                                =20
--------------  Memory Error Log Information  --------------
Timestamp =3D   Sun Sep  29 14:40:30 GMT 2013    (20:13:09:29:14:40:30)

  OV  RQ  RS      ESTAT      A  C  D  corr  unc  fe  cw  pf
  --  --  --      -----      -  -  -  ----  ---  --  --  --
          X    ERR_TIMEOUT                              =20


  General Bus Logs:=20
    REQUESTOR_ID               =3D 0x0000000000000000
    RESPONDER_ID               =3D 0x0000000000000000
    TARGET_ID                  =3D 0x00014dbc42204190
    BUS_SPECIFIC_DATA          =3D 0x0000000000189000
    ERROR_LOG_EN               =3D 0x0000000000001dff
    ERROR_SIG_EN               =3D 0x0000000000000157
    ERROR_STATUS               =3D 0x0000000000000008
    ERROR_OVFL                 =3D 0x0000000000000000
    ERROR_FIRST                =3D 0x0000000000000000
                                                                =20
  Detailed Bus Logs: =20
    AP_ADDRa      =3D 0x0000000000000000
    AP_ADDRb      =3D 0x0000000000000000
    ST_ADDRa      =3D 0x0000000000000000
    ST_ADDRb      =3D 0x0000000000000000
    RT_ADDRa      =3D 0x00494dbc42204190
    RT_ADDRb      =3D 0x0030000700001418
    RP_ADDRa      =3D 0x0000000000000000
    RP_ADDRb      =3D 0x0000000000000000
    LE_ADDRa      =3D 0x0000000000000000
    LE_ADDRb      =3D 0x0000000000000000
    ST_TO         =3D 0x0000000000011001
    PT_TO         =3D 0x000000000007a120
    RT_TO         =3D 0x0000000000010003


                                                                =20
------------  I/O Module Error Log Information  ------------

  No IO subsystem errors recorded


--Apple-Mail-4-787863263--

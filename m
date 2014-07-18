Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbaGRBHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:07:40 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:57181 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbaGRBHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:07:39 -0400
MIME-Version: 1.0
In-Reply-To: <53C7CF5E.50506@compro.net>
References: <1498242287.361986.1405561014562.JavaMail.root@mx2.compro.net>
	<53C7CF5E.50506@compro.net>
Date: Fri, 18 Jul 2014 10:07:38 +0900
Message-ID: <CAHb8M2DXA2Q-kkGyCJpMjunRYU4zsddBHeaOzC2JzCYAhYpyng@mail.gmail.com>
Subject: Re: [PATCH] staging: dgap: introduce dgap_cleanup_nodes()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Mark Hounschell <markh@compro.net>
Cc: Lidza Louina <lidza.louina@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark.

Thanks for testing.

I am trying to solve this problem with config sample which is sent by you.

regards,
Daeseok Youn.

2014-07-17 22:27 GMT+09:00 Mark Hounschell <markh@compro.net>:
> On 07/16/2014 09:35 PM, Daeseok Youn wrote:
>> When a configration file is parsed with dgap_parsefile(),
>> makes nodes for saving configrations for board.
>>
>> Making a node will allocate node memory and strings for saving
>> configrations with kstrdup().
>>
>> So these are freed when dgap is unloaded or failed to initialize.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> Mark, please review this patch.
>> Thanks.
>>
>>   drivers/staging/dgap/dgap.c |   47 +++++++++++++++++++++++++++++++++++++++++++
>>   1 files changed, 47 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
>> index 06c55cb..e9df2ea 100644
>> --- a/drivers/staging/dgap/dgap.c
>> +++ b/drivers/staging/dgap/dgap.c
>> @@ -201,6 +201,7 @@ static int dgap_test_fep(struct board_t *brd);
>>   static int dgap_tty_register_ports(struct board_t *brd);
>>   static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
>>                             struct board_t *brd);
>> +static void dgap_cleanup_nodes(void);
>>
>>   static void dgap_cleanup_module(void);
>>
>> @@ -619,6 +620,7 @@ unregister_tty:
>>   free_flipbuf:
>>       dgap_free_flipbuf(brd);
>>   cleanup_brd:
>> +     dgap_cleanup_nodes();
>>       dgap_release_remap(brd);
>>       kfree(brd);
>>
>> @@ -659,6 +661,8 @@ static void dgap_cleanup_module(void)
>>               dgap_cleanup_board(dgap_board[i]);
>>       }
>>
>> +     dgap_cleanup_nodes();
>> +
>>       if (dgap_numboards)
>>               pci_unregister_driver(&dgap_driver);
>>   }
>> @@ -6323,6 +6327,49 @@ static void dgap_remove_tty_sysfs(struct device *c)
>>       sysfs_remove_group(&c->kobj, &dgap_tty_attribute_group);
>>   }
>>
>> +static void dgap_cleanup_nodes(void)
>> +{
>> +     struct cnode *p;
>> +
>> +     p = &dgap_head;
>> +
>> +     while (p) {
>> +             struct cnode *tmp = p->next;
>> +
>> +             switch (p->type) {
>> +             case BNODE:
>> +                     kfree(p->u.board.portstr);
>> +                     kfree(p->u.board.addrstr);
>> +                     kfree(p->u.board.pcibusstr);
>> +                     kfree(p->u.board.pcislotstr);
>> +                     kfree(p->u.board.method);
>> +                     break;
>> +             case CNODE:
>> +                     kfree(p->u.conc.id);
>> +                     kfree(p->u.conc.connect);
>> +                     break;
>> +             case MNODE:
>> +                     kfree(p->u.module.id);
>> +                     break;
>> +             case TNODE:
>> +                     kfree(p->u.ttyname);
>> +                     break;
>> +             case CUNODE:
>> +                     kfree(p->u.cuname);
>> +                     break;
>> +             case LNODE:
>> +                     kfree(p->u.line.cable);
>> +                     break;
>> +             case PNODE:
>> +                     kfree(p->u.printname);
>> +                     break;
>> +             }
>> +
>> +             kfree(p->u.board.status);
>> +             kfree(p);
>> +             p = tmp;
>> +     }
>> +}
>>   /*
>>    * Parse a configuration file read into memory as a string.
>>    */
>>
>
> I get a kernel oops when unloading the driver with this patch.
>
> 2014-07-17T09:22:12.666987-04:00 harley kernel: [60216.979134] task: ffff8801037846b0 ti: ffff880149256000 task.ti: ffff880149256000
> 2014-07-17T09:22:12.666988-04:00 harley kernel: [60216.979136] RIP: 0010:[<ffffffff8034d5ff>]  [<ffffffff8034d5ff>] kfree+0x17f/0x190
> 2014-07-17T09:22:12.666989-04:00 harley kernel: [60216.979143] RSP: 0018:ffff880149257e78  EFLAGS: 00010246
> 2014-07-17T09:22:12.666991-04:00 harley kernel: [60216.979144] RAX: 4000000000080068 RBX: ffffffffa0428d20 RCX: 00000000038eb895
> 2014-07-17T09:22:12.666992-04:00 harley kernel: [60216.979146] RDX: 4000000000080068 RSI: ffffea0004131e00 RDI: ffffffffa0428d20
> 2014-07-17T09:22:12.666993-04:00 harley kernel: [60216.979147] RBP: ffff880149257e90 R08: 0000000000015b60 R09: ffff88014fd55b60
> 2014-07-17T09:22:12.666994-04:00 harley kernel: [60216.979149] R10: ffffea0000810a00 R11: ffffffffa0424ffd R12: ffff88005a3d2a80
> 2014-07-17T09:22:12.666995-04:00 harley kernel: [60216.979150] R13: ffffffffa041c155 R14: 0000000000000002 R15: 0000000000000bc0
> 2014-07-17T09:22:12.666996-04:00 harley kernel: [60216.979152] FS:  00007fb7d51d2700(0000) GS:ffff88014fd40000(0000) knlGS:0000000000000000
> 2014-07-17T09:22:12.666997-04:00 harley kernel: [60216.979154] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> 2014-07-17T09:22:12.666998-04:00 harley kernel: [60216.979155] CR2: 00007fe66ee4e000 CR3: 00000001497af000 CR4: 00000000000407e0
> 2014-07-17T09:22:12.666999-04:00 harley kernel: [60216.979156] Stack:
> 2014-07-17T09:22:12.667000-04:00 harley kernel: [60216.979157]  ffffffffa0428d20 ffff88005a3d2a80 ffff8801259dd330 ffff880149257eb0
> 2014-07-17T09:22:12.667001-04:00 harley kernel: [60216.979161]  ffffffffa041c155 0000000000000700 ffff8801259dd000 ffff880149257ee8
> 2014-07-17T09:22:12.667002-04:00 harley kernel: [60216.979164]  ffffffffa0424ee8 0000000000000000 ffffffff80c92700 ffffffffa04289e0
> 2014-07-17T09:22:12.667002-04:00 harley kernel: [60216.979167] Call Trace:
> 2014-07-17T09:22:12.667003-04:00 harley kernel: [60216.979172]  [<ffffffffa041c155>] dgap_cleanup_nodes+0x45/0xb0 [dgap]
> 2014-07-17T09:22:12.667004-04:00 harley kernel: [60216.979176]  [<ffffffffa0424ee8>] dgap_cleanup_module+0x3a8/0x4e0 [dgap]
> 2014-07-17T09:22:12.667005-04:00 harley kernel: [60216.979180]  [<ffffffff802b1d9f>] SyS_delete_module+0x15f/0x220
> 2014-07-17T09:22:12.667006-04:00 harley kernel: [60216.979183]  [<ffffffff803326c4>] ? vm_munmap+0x54/0x70
> 2014-07-17T09:22:12.667007-04:00 harley kernel: [60216.979186]  [<ffffffff80787b62>] system_call_fastpath+0x16/0x1b
> 2014-07-17T09:22:12.667008-04:00 harley kernel: [60216.979188] Code: 42 00 e9 65 ff ff ff 49 f7 02 00 c0 00 00 74 1b 49 8b 02 31 f6 f6 c4 40 74 04 41 8b 72 68 4c 89 d7 e8 f6 e8 fb ff e9 41 ff ff ff <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5
> 2014-07-17T09:22:12.667009-04:00 harley kernel: [60216.979211] RIP  [<ffffffff8034d5ff>] kfree+0x17f/0x190
> 2014-07-17T09:22:12.667010-04:00 harley kernel: [60216.979214]  RSP <ffff880149257e78>
> 2014-07-17T09:22:12.667011-04:00 harley kernel: [60216.979216] ---[ end trace bbd37a5663615b1c ]---
>
> Regards
> Mark

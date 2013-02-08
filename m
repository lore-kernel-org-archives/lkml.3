Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947173Ab3BHWbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:31:43 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:57028 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760466Ab3BHWbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:31:41 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
Subject: RE: [PATCH v5 -next 0/2] make efivars/efi_pstore interrupt-safe
Thread-Topic: [PATCH v5 -next 0/2] make efivars/efi_pstore interrupt-safe
Thread-Index: Ac35yqIe9BPiMcvaTbaUDFx/K7uN/AMf3gnw
Date: Fri, 8 Feb 2013 22:31:27 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A884D6@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A5419C@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A5419C@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-02-08_07:2013-02-08,2013-02-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1302080226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

Can you please take a look at this patchset which removes create_sysfs_entries() from efi_pstore_write()?

It has been updated in accordance with Mike's comment and fixes an actual bug.
http://comments.gmane.org/gmane.linux.kernel.efi/406

Seiji

> -----Original Message-----
> From: Seiji Aguchi
> Sent: Wednesday, January 23, 2013 7:41 PM
> To: linux-kernel@vger.kernel.org; linux-efi@vger.kernel.org; Luck, Tony (tony.luck@intel.com); mikew@google.com;
> matt.fleming@intel.com; cbouatmailru@gmail.com; dzickus@redhat.com
> Cc: dle-develop@lists.sourceforge.net; Satoru Moriya
> Subject: [PATCH v5 -next 0/2] make efivars/efi_pstore interrupt-safe
> 
> Changelogv4 -> v5
>    - Rebase from a linus tree to a linux-next tree to avoid getting
>      a conflict when this patchset is merged to a linux-next tree.
>    - Merge previous patches 2/3 and 3/3 into 2/2 because they fix
>      a same problem.
>    - Modify to fit a latest upstream kernel as follows.
>     - Change spinlock operations of efivarfs which has been
>       introduced recently.(Patch 1/2)
>     - Remove delete_all_stale_sysfs_entries() from update_sysfs_entries()
>       because a currnet efi_pstore doesn't erase existing entries
>       in a write callback and sysfs entries don't become stale.
>       (Patch 2/2)
> 
> v3 -> v4
>   - Patch 2/3
>     Move cancel_work_sync() above an efi_enabled test in efivars_exit().
> 
> v2 -> v3
>   - Patch 1/3
>     Replace spin_lock_irqsave/spin_unlock_irqrestore with spin_lock_irq/spin_unlock_irq in efivars_unregister(),
>     efivar_create(), efivar_store_raw() and efivar_delete() which are called in a process context.
> 
>  - Patch 2/3
>     Change a name of delete_sysfs_entry() to delete_all_stale_sysfs_entries().
>     Also, don't release an efivar->lock while searching efivar->list in delete_all_stale_sysfs_entries().
> 
>  - Patch 3/3
>     Remove a logic in efi_pstore_erase() which freshly created in patch v2.
> 
> v1 -> v2
>  - Patch 1/3
>     Add spin_lock_irq/spin_unlock_irq to open/close callbacks of efi_pstore
>     instead of moving spin_locks to a read callback.
> 
>  - Patch 2/3
>     Replace a periodical timer with schedule_work().
> 
>  - Patch 3/3
>     freshly create to kick a workqueue in oops case only.
> 
> [Problem]
>  There are following problems related to an interrupt context in efivars  including efivarfs and efi_pstore.
> 
> (1)There is a scenario which efi_pstore fails to log messages
>    in a panic case.
> 
>    - CPUA holds an efi_var->lock in either efivarfs parts
>      or efi_pstore with interrupt enabled.
>    - CPUB panics and sends IPI to CPUA in smp_send_stop().
>    - CPUA stops with holding the lock.
>    - CPUB kicks efi_pstore_write() via kmsg_dump(KSMG_DUMP_PANIC)
>      but it returns without logging messages.
> 
> (2)Also, efi_pstore creates sysfs entries, which enable users to access to
>    NVRAM, in a write callback.
>    If a kernel panic happens in an interrupt contexts, pstore may fail
>    because it could sleep due to dynamic memory allocations during creating
>    sysfs entries.
>    An actual failure due to the create_sysfs_entry() has been reported.
>    http://comments.gmane.org/gmane.linux.kernel.efi/406
> 
> To resolve problems above, this patchset makes efivars/efi_pstore interrupt-safe.
> 
> [Patch Description]
>   Please see detailed explanations in each patch.
> 
> Seiji Aguchi (2):
>   efivars: Disable external interrupt while holding efivars->lock
>    - This patch fixes a problem (1).
> 
>   efi_pstore: Introducing workqueue updating sysfs entries
>    - This patch fixes a problem (2).
> 
>  drivers/firmware/efivars.c |  171 ++++++++++++++++++++++++++++++++------------
>  include/linux/efi.h        |    3 +-
>  2 files changed, 126 insertions(+), 48 deletions(-)

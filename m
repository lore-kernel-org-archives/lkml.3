Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3JUXbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 19:31:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab3JUXbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 19:31:07 -0400
Date: Tue, 22 Oct 2013 10:30:51 +1100
From: NeilBrown <neilb@suse.de>
To: ycbzzjlby@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        majianpeng@gmail.com, Bian Yu <bianyu@kedacom.com>
Subject: Re: [PATCH] md: avoid deadlock when md_set_badblocks.
Message-ID: <20131022103051.30f899b9@notabene.brown>
In-Reply-To: <1381554603-1695-1-git-send-email-ycbzzjlby@gmail.com>
References: <1381554603-1695-1-git-send-email-ycbzzjlby@gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qsIdgHWxt.tM2K=7C4InKur"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qsIdgHWxt.tM2K=7C4InKur
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 12 Oct 2013 01:10:03 -0400 ycbzzjlby@gmail.com wrote:

> From: Bian Yu <bianyu@kedacom.com>
>=20
> When operate harddisk and hit errors, md_set_badblocks is called after
> scsi_restart_operations which already disabled the irq. but md_set_badblo=
cks
> will call write_sequnlock_irq and enable irq. so softirq can preempt the
> current thread and that may cause a deadlock. I think this situation shou=
ld
> use write_sequnlock_irqsave/irqrestore instead.
>=20
> I met the situation and the call trace is below:
> [  638.919974] BUG: spinlock recursion on CPU#0, scsi_eh_13/1010
> [  638.921923]  lock: 0xffff8800d4d51fc8, .magic: dead4ead, .owner: scsi_=
eh_13/1010, .owner_cpu: 0
> [  638.923890] CPU: 0 PID: 1010 Comm: scsi_eh_13 Not tainted 3.12.0-rc5+ =
#37
> [  638.925844] Hardware name: To be filled by O.E.M. To be filled by O.E.=
M./MAHOBAY, BIOS 4.6.5 03/05/2013
> [  638.927816]  ffff880037ad4640 ffff880118c03d50 ffffffff8172ff85 000000=
0000000007
> [  638.929829]  ffff8800d4d51fc8 ffff880118c03d70 ffffffff81730030 ffff88=
00d4d51fc8
> [  638.931848]  ffffffff81a72eb0 ffff880118c03d90 ffffffff81730056 ffff88=
00d4d51fc8
> [  638.933884] Call Trace:
> [  638.935867]  <IRQ>  [<ffffffff8172ff85>] dump_stack+0x55/0x76
> [  638.937878]  [<ffffffff81730030>] spin_dump+0x8a/0x8f
> [  638.939861]  [<ffffffff81730056>] spin_bug+0x21/0x26
> [  638.941836]  [<ffffffff81336de4>] do_raw_spin_lock+0xa4/0xc0
> [  638.943801]  [<ffffffff8173f036>] _raw_spin_lock+0x66/0x80
> [  638.945747]  [<ffffffff814a73ed>] ? scsi_device_unbusy+0x9d/0xd0
> [  638.947672]  [<ffffffff8173fb1b>] ? _raw_spin_unlock+0x2b/0x50
> [  638.949595]  [<ffffffff814a73ed>] scsi_device_unbusy+0x9d/0xd0
> [  638.951504]  [<ffffffff8149ec47>] scsi_finish_command+0x37/0xe0
> [  638.953388]  [<ffffffff814a75e8>] scsi_softirq_done+0xa8/0x140
> [  638.955248]  [<ffffffff8130e32b>] blk_done_softirq+0x7b/0x90
> [  638.957116]  [<ffffffff8104fddd>] __do_softirq+0xfd/0x330
> [  638.958987]  [<ffffffff810b964f>] ? __lock_release+0x6f/0x100
> [  638.960861]  [<ffffffff8174a5cc>] call_softirq+0x1c/0x30
> [  638.962724]  [<ffffffff81004c7d>] do_softirq+0x8d/0xc0
> [  638.964565]  [<ffffffff8105024e>] irq_exit+0x10e/0x150
> [  638.966390]  [<ffffffff8174ad4a>] smp_apic_timer_interrupt+0x4a/0x60
> [  638.968223]  [<ffffffff817499af>] apic_timer_interrupt+0x6f/0x80
> [  638.970079]  <EOI>  [<ffffffff810b964f>] ? __lock_release+0x6f/0x100
> [  638.971899]  [<ffffffff8173fa6a>] ? _raw_spin_unlock_irq+0x3a/0x50
> [  638.973691]  [<ffffffff8173fa60>] ? _raw_spin_unlock_irq+0x30/0x50
> [  638.975475]  [<ffffffff81562393>] md_set_badblocks+0x1f3/0x4a0
> [  638.977243]  [<ffffffff81566e07>] rdev_set_badblocks+0x27/0x80
> [  638.978988]  [<ffffffffa00d97bb>] raid5_end_read_request+0x36b/0x4e0 [=
raid456]
> [  638.980723]  [<ffffffff811b5a1d>] bio_endio+0x1d/0x40
> [  638.982463]  [<ffffffff81304ff3>] req_bio_endio.isra.65+0x83/0xa0
> [  638.984214]  [<ffffffff81306b9f>] blk_update_request+0x7f/0x350
> [  638.985967]  [<ffffffff81306ea1>] blk_update_bidi_request+0x31/0x90
> [  638.987710]  [<ffffffff813085e0>] __blk_end_bidi_request+0x20/0x50
> [  638.989439]  [<ffffffff8130862f>] __blk_end_request_all+0x1f/0x30
> [  638.991149]  [<ffffffff81308746>] blk_peek_request+0x106/0x250
> [  638.992861]  [<ffffffff814a62a9>] ? scsi_kill_request.isra.32+0xe9/0x1=
30
> [  638.994561]  [<ffffffff814a633a>] scsi_request_fn+0x4a/0x3d0
> [  638.996251]  [<ffffffff813040a7>] __blk_run_queue+0x37/0x50
> [  638.997900]  [<ffffffff813045af>] blk_run_queue+0x2f/0x50
> [  638.999553]  [<ffffffff814a5750>] scsi_run_queue+0xe0/0x1c0
> [  639.001185]  [<ffffffff814a7721>] scsi_run_host_queues+0x21/0x40
> [  639.002798]  [<ffffffff814a2e87>] scsi_restart_operations+0x177/0x200
> [  639.004391]  [<ffffffff814a4fe9>] scsi_error_handler+0xc9/0xe0
> [  639.005996]  [<ffffffff814a4f20>] ? scsi_unjam_host+0xd0/0xd0
> [  639.007600]  [<ffffffff81072f6b>] kthread+0xdb/0xe0
> [  639.009205]  [<ffffffff81072e90>] ? flush_kthread_worker+0x170/0x170
> [  639.010821]  [<ffffffff81748cac>] ret_from_fork+0x7c/0xb0
> [  639.012437]  [<ffffffff81072e90>] ? flush_kthread_worker+0x170/0x170
>=20
> Signed-off-by: Bian Yu <bianyu@kedacom.com>
> Reviewed-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 8a0d762..2445fec 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8111,6 +8111,7 @@ static int md_set_badblocks(struct badblocks *bb, s=
ector_t s, int sectors,
>  	u64 *p;
>  	int lo, hi;
>  	int rv =3D 1;
> +	unsigned long flags;
> =20
>  	if (bb->shift < 0)
>  		/* badblocks are disabled */
> @@ -8125,7 +8126,7 @@ static int md_set_badblocks(struct badblocks *bb, s=
ector_t s, int sectors,
>  		sectors =3D next - s;
>  	}
> =20
> -	write_seqlock_irq(&bb->lock);
> +	write_seqlock_irqsave(&bb->lock, flags);
> =20
>  	p =3D bb->page;
>  	lo =3D 0;
> @@ -8241,7 +8242,7 @@ static int md_set_badblocks(struct badblocks *bb, s=
ector_t s, int sectors,
>  	bb->changed =3D 1;
>  	if (!acknowledged)
>  		bb->unacked_exist =3D 1;
> -	write_sequnlock_irq(&bb->lock);
> +	write_sequnlock_irqrestore(&bb->lock, flags);
> =20
>  	return rv;
>  }


Applied, thanks.
NeilBrown

--Sig_/qsIdgHWxt.tM2K=7C4InKur
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmW5LDnsnt1WYoG5AQKGzg//bRu0KnYkUdQ14xAWQlYykdvvQTeST01J
qb9IQyTDP3GQXlJ7qBCzJPiQAWGliEum4sq1878MixaR6sn2dJyF8GEI76ZUHITC
gvv9q4nxwLA7ZMxCIgXfI6voHW6vwUha+rZxI+EYOK0c6SctQUzuUmtij3fVQCik
sInzu86kZiZlZKD9BsM2CniGmIYFga/zpK1sDwy3vdSqpkZA/lYD/yMh13LjMcFZ
cSge0upop6Mo+eBmnKlbPqzOLfqx1H3ODb3vTFT+PZTu6WEfW5vMQoGWAHjbHyLa
zGWlEzDLxUGPTd7zt69g7gHXqgP9WqorLkD7oh2l8jjcLlMnqgD49IAQDYz6ITUU
U3sw6YVWaCmqJwGv2vbByCgoyLU3r6ksEoyexLsqwktjUAcuYxUJqPl1SM74+nUG
6g5y18Zrls5yyFGnci3r9lRhPssN2AG3Vj+5Vk/857e5ui2d7yskAey3005m2yBM
kRzyI0u3bcCwNROSG5LVqvqjH+WI7VNm0FgttM6/bjir6bB67wQM5fh4xeVo2rgZ
yXpzmZjYNrzAtMcDLuntutRSTeozNKG+y+QAT1FmrjZkRB2fxbZJ/lITRM1pLl0D
4KOpMZgNuAfnNWssdyIVUBdQFz7Pjxx1wjAeL/zRgHvO9NLUiImkpojpqh3hIrKd
mKVUWxWyoug=
=VzPU
-----END PGP SIGNATURE-----

--Sig_/qsIdgHWxt.tM2K=7C4InKur--

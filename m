Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847AbaGBU0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:26:38 -0400
Received: from p01c11o148.mxlogic.net ([208.65.144.71]:34712 "EHLO
	p01c11o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbaGBU0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:26:35 -0400
X-MXL-Hash: 53b46afa6bf0099f-5c7249cc5698a359ead8690c458a940066b6e1ef
Date: Wed, 2 Jul 2014 16:26:26 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
To: Joe Lawrence <joe.lawrence@stratus.com>
CC: <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "Jiri Kosina" <jkosina@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v3 0/2] block,scsi: fixup blk_get_request dead queue
 scenarios
Message-ID: <20140702162626.5fcaf2a1@jlaw-desktop.mno.stratus.com>
In-Reply-To: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>
References: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AnalysisOut: [v=2.1 cv=bv/CBSqi c=1 sm=1 tr=0 a=o2bo05G+d1rlxuoNbFVhCw==]
X-AnalysisOut: [:117 a=o2bo05G+d1rlxuoNbFVhCw==:17 a=2KTiUk5DT3cA:10 a=_KQ]
X-AnalysisOut: [qW7t0BisA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=uelBKuK]
X-AnalysisOut: [pAAAA:8 a=YlVTAMxIAAAA:8 a=zUH0V0KGEoIccrHwrzMA:9 a=CjuIK1]
X-AnalysisOut: [q_8ugA:10]
X-Spam: [F=0.6000000000; CM=0.500; MH=0.600(2014070216); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW, I spent some time looking at blk_get_request callers and as far as
I can tell, most should be able to gracefully handle additional errno
values of -ENODEV and -EWOULDBLOCK.  I didn't chase down the pktcdvd or
osd paths, however Jiri and Boaz ack'd the earlier patch version that
added -ENODEV.

Here are my wide-screen notes from the cscope goose-chase...


Functions calling this function: blk_get_request

  File                Function              Line                                                                                 Return value handling
0 blk-core.c          blk_make_request      1217 struct request *rq = blk_get_request(q, bio_data_dir(bio), gfp_mask);           ERR_PTR propagated, see callers below, TODO
1 bsg.c               bsg_map_hdr            272 rq = blk_get_request(q, rw, GFP_KERNEL);                                        ERR_PTR propagated, see callers below
2 bsg.c               bsg_map_hdr            287 next_rq = blk_get_request(q, READ, GFP_KERNEL);                                 ERR_PTR propagated, see callers below
3 scsi_ioctl.c        sg_io                  310 rq = blk_get_request(q, writing ? WRITE : READ, GFP_KERNEL);                    PTR_ERR propagated, see callers below
4 scsi_ioctl.c        sg_scsi_ioctl          440 rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);                     PTR_ERR propagated, see callers below
5 scsi_ioctl.c        __blk_send_generic     526 rq = blk_get_request(q, WRITE, __GFP_WAIT);                                     PTR_ERR propagated, see callers below
6 pd.c                action                 724 rq = blk_get_request(disk->gd->queue, READ, __GFP_WAIT);                        caller is actually "pd_special_command", PTR_ERR propagated, see callers below
7 pktcdvd.c           pkt_generic_packet     705 rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?               PTR_ERR propagated, see callers below, TODO
8 sx8.c               carm_get_special       570 rq = blk_get_request(host->oob_q, WRITE , GFP_KERNEL);                          return code is NULL
9 cdrom.c             cdrom_read_cdda_bpc   2182 rq = blk_get_request(q, READ, GFP_KERNEL);                                      filters out -EIO, PTR_ERR propagated, see callers below
a ide-atapi.c         ide_queue_pc_tail       95 rq = blk_get_request(drive->queue, READ, __GFP_WAIT);                           don't care, deprecated driver
b ide-cd.c            ide_cd_queue_pc        444 rq = blk_get_request(drive->queue, write, __GFP_WAIT);                          don't care, deprecated driver
c ide-cd_ioctl.c      ide_cdrom_reset        306 rq = blk_get_request(drive->queue, READ, __GFP_WAIT);                           don't care, deprecated driver
d ide-devsets.c       ide_devset_execute     168 rq = blk_get_request(q, READ, __GFP_WAIT);                                      don't care, deprecated driver
e ide-disk.c          set_multcount          480 rq = blk_get_request(drive->queue, READ, __GFP_WAIT);                           don't care, deprecated driver
f ide-ioctls.c        ide_cmd_ioctl          128 rq = blk_get_request(drive->queue, READ, __GFP_WAIT);                           don't care, deprecated driver
g ide-ioctls.c        generic_drive_reset    224 rq = blk_get_request(drive->queue, READ, __GFP_WAIT);                           don't care, deprecated driver
h ide-park.c          issue_park_cmd          34 rq = blk_get_request(q, READ, __GFP_WAIT);                                      caller is void
i ide-park.c          issue_park_cmd          48 rq = blk_get_request(q, READ, GFP_NOWAIT);                                      don't care, deprecated driver
j ide-pm.c            generic_ide_suspend     21 rq = blk_get_request(drive->queue, READ, __GFP_WAIT);                           don't care, deprecated driver
k ide-pm.c            generic_ide_resume      61 rq = blk_get_request(drive->queue, READ, __GFP_WAIT);                           don't care, deprecated driver
l ide-tape.c          idetape_queue_rw_tail  855 rq = blk_get_request(drive->queue, READ, __GFP_WAIT);                           don't care, deprecated driver
m ide-taskfile.c      ide_raw_taskfile       433 rq = blk_get_request(drive->queue, rw, __GFP_WAIT);                             don't care, deprecated driver
n scsi_dh_alua.c      get_alua_req           116 rq = blk_get_request(q, rw, GFP_NOIO);                                          return code is NULL
o scsi_dh_emc.c       get_req                276 rq = blk_get_request(sdev->request_queue,                                       return code is NULL
p scsi_dh_hp_sw.c     hp_sw_tur              119 req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);                    return code is driver/core specific
q scsi_dh_hp_sw.c     hp_sw_start_stop       249 req = blk_get_request(h->sdev->request_queue, WRITE, GFP_ATOMIC);               return code is driver/core specific
r scsi_dh_rdac.c      get_rdac_req           275 rq = blk_get_request(q, rw, GFP_NOIO);                                          return code is NULL
s osd_initiator.c     _make_request         1569 req = blk_get_request(q, has_write ? WRITE : READ, flags);                      ERR_PTR propagated, see callers below, TODO
t osst.c              osst_execute           364 req = blk_get_request(SRpnt->stp->device->request_queue, write, GFP_KERNEL);    return code is driver/core specific
u scsi_error.c        scsi_eh_lock_door     1953 req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);                   caller is void
v scsi_lib.c          scsi_execute           195 req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);                  return code is driver/core specific
w scsi_tgt_lib.c      scsi_host_get_command   99 rq = blk_get_request(shost->uspace_req_q, !write, gfp_mask);                    return code is NULL
x sg.c                sg_start_req          1652 rq = blk_get_request(q, rw, GFP_ATOMIC);                                        PTR_ERR propagated, see callers below
y st.c                st_scsi_execute        482 req = blk_get_request(SRpnt->stp->device->request_queue, write,                 return code is driver/core specific
z target_core_pscsi.c pscsi_execute_cmd     1050 req = blk_get_request(pdv->pdv_sd->request_queue,                               return code is driver/core specific


Functions calling this function: blk_make_request

  File                Function          Line
0 virtio_blk.c        virtblk_get_id     241 req = blk_make_request(vblk->disk->queue, bio, GFP_KERNEL);                         PTR_ERR propagated, see callers below
1 osd_initiator.c     _make_request     1565 return blk_make_request(q, oii->bio, flags);                                        ERR_PTR propagated, see callers below, TODO
2 target_core_pscsi.c pscsi_execute_cmd 1067 req = blk_make_request(pdv->pdv_sd->request_queue, hbio,                            return code is driver/core specific


Functions calling this function: virtblk_get_id

  File         Function            Line
0 virtio_blk.c virtblk_serial_show 318 err = virtblk_get_id(disk, buf);                                                          Filters out -EIO, others propagated, caller is a DEVICE_ATTR


Functions calling this function: _make_request

  File            Function          Line
0 osd_initiator.c _init_blk_request 1587 req = _make_request(q, has_out, has_out ? &or->out : &or->in, flags);                   PTR_ERR propagated, see callers below, TDOO
1 osd_initiator.c _init_blk_request 1605 req = _make_request(q, false, &or->in, flags);                                          PTR_ERR propagated, see callers below, TODO


Functions calling this function: _init_blk_request

  File            Function             Line
0 osd_initiator.c osd_finalize_request 1654 ret = _init_blk_request(or, has_in, has_out);                                        PTR_ERR propagated, see callers below


Functions calling this function: osd_finalize_request

  File            Function                   Line
0 osdblk.c        osd_sync_op                151 ret = osd_finalize_request(or, 0, credential, NULL);                            PTR_ERR propagated, see callers below, TODO
1 osdblk.c        osd_async_op               169 ret = osd_finalize_request(or, 0, cred, NULL);                                  PTR_ERR propagated, see callers below, TODO
2 osd_initiator.c _osd_get_print_system_info 109 ret = osd_finalize_request(or, 0, caps, NULL);                                  PTR_ERR propagated, see callers below, TODO
3 ore.c           ore_io_execute             376 ret = osd_finalize_request(or, 0, _ios_cred(ios, i), NULL);                     PTR_ERR propagated, see callers below, TODO
4 super.c         exofs_read_kern            242 ret = osd_finalize_request(or, 0, cred, NULL);                                  PTR_ERR propagated, see callers below, TODO


Functions calling this function: bsg_map_hdr

  File  Function    Line
0 bsg.c __bsg_write 649 rq = bsg_map_hdr(bd, &bc->hdr, has_write_perm, bc->sense);                                               PTR_ERR propagated, see callers below
1 bsg.c bsg_ioctl   937 rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE, sense);                                           PTR_ERR propagated, caller is a file_operations.unlocked_ioctl method


Functions calling this function: __bsg_write

  File  Function  Line
0 bsg.c bsg_write 682 ret = __bsg_write(bd, buf, count, &bytes_written,                                                          PTR_ERR propagated, caller is a file_operations.write method


Functions calling this function: sg_io

  File         Function       Line
0 scsi_ioctl.c scsi_cmd_ioctl 586 err = sg_io(q, bd_disk, &hdr, mode);                                                           If !EFAULT, calls copy_to_user and sets -EFAULT
1 scsi_ioctl.c scsi_cmd_ioctl 634 err = sg_io(q, bd_disk, &hdr, mode);


Functions calling this function: sg_scsi_ioctl

  File         Function       Line
0 scsi_ioctl.c scsi_cmd_ioctl  658 err = sg_scsi_ioctl(q, bd_disk, mode, arg);                                                   PTR_ERR propagated, see callers below
1 scsi_ioctl.c scsi_ioctl      247 return sg_scsi_ioctl(sdev->request_queue, NULL, 0, arg);                                      PTR_ERR propagated, see callers below
2 sg.c         sg_ioctl       1083 return sg_scsi_ioctl(sdp->device->request_queue, NULL, filp->f_mode, p);                      PTR_ERR propagated, caller is a file_operations .unlocked_ioctl method
3 blkdev.h     sg_ioctl        820 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,                   not a function


Functions calling this function: scsi_cmd_ioctl

  File         Function           Line
0 bsg.c        bsg_ioctl           925 return scsi_cmd_ioctl(bd->queue, NULL, file->f_mode, cmd, uarg);                          PTR_ERR propagated, see callers above
1 scsi_ioctl.c scsi_cmd_blk_ioctl  724 return scsi_cmd_ioctl(bd->bd_disk->queue, bd->bd_disk, mode, cmd, arg);                   PTR_ERR propagated, see callers below
2 skd_main.c   skd_bdev_ioctl     1277 rc = scsi_cmd_ioctl(disk->queue, disk, mode, cmd_in, p);                                  PTR_ERR propagated, caller is a block_device_operations .compat_ioctl method
3 st.c         st_ioctl           3662 i = scsi_cmd_ioctl(STp->disk->queue, STp->disk,                                           PTR_ERR propagated, caller is a file_operations .compat_ioctl method
4 blkdev.h     st_ioctl            818 extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,              not a function


Functions calling this function: scsi_cmd_blk_ioctl

  File               Function         Line
0 cciss.c            cciss_ioctl      1753 return scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);                                     PTR_ERR propagated, see callers below
1 virtio_blk.c       virtblk_ioctl     266 return scsi_cmd_blk_ioctl(bdev, mode, cmd,                                            PTR_ERR propagated, caller is a block_device_operations .ioctl method
2 cdrom.c            cdrom_ioctl      3314 ret = scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);                                      PTR_ERR propagated, see callers below
3 ide-floppy_ioctl.c ide_floppy_ioctl  295 err = scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);                                      PTR_ERR propagated, caller is a ide_disk_ops .compat_ioctl method
4 sd.c               sd_ioctl         1304 error = scsi_cmd_blk_ioctl(bdev, mode, cmd, p);                                       PTR_ERR propagated, caller is a block_device_operations .compat_ioctl method
5 blkdev.h           sd_ioctl          816 extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,                         not a function


Functions calling this function: cciss_ioctl

  File    Function                   Line
0 cciss.c cciss_compat_ioctl         1170 return cciss_ioctl(bdev, mode, cmd, arg);                                              PTR_ERR propagated, caller is a block_device_operations .compat_ioctl method
1 cciss.c cciss_ioctl32_passthru     1211 err = cciss_ioctl(bdev, mode, CCISS_PASSTHRU, (unsigned long )p);                      PTR_ERR propagated, see callers below
2 cciss.c cciss_ioctl32_big_passthru 1253 err = cciss_ioctl(bdev, mode, CCISS_BIG_PASSTHRU, (unsigned long )p);                  PTR_ERR propagated, see callers below


Functions calling this function: cciss_ioctl32_passthru

  File    Function           Line
0 cciss.c cciss_compat_ioctl 1173 return cciss_ioctl32_passthru(bdev, mode, cmd, arg);                                           PTR_ERR propagated, see callers above


Functions calling this function: cciss_ioctl32_big_passthru

  File    Function           Line
0 cciss.c cciss_compat_ioctl 1175 return cciss_ioctl32_big_passthru(bdev, mode, cmd, arg);                                       PTR_ERR propagated, see callers above


Functions calling this function: cdrom_ioctl

  File     Function           Line
0 pcd.c    pcd_block_ioctl     254 ret = cdrom_ioctl(&cd->info, bdev, mode, cmd, arg);                                           PTR_ERR propagated, caller is a block_device_operations .ioctl method
1 gdrom.c  gdrom_bdops_ioctl   525 ret = cdrom_ioctl(gd.cd_info, bdev, mode, cmd, arg);                                          PTR_ERR propagated, caller is a block_device_operations .ioctl method
2 ide-cd.c idecd_locked_ioctl 1676 err = cdrom_ioctl(&info->devinfo, bdev, mode, cmd, arg);                                      PTR_ERR propagated, see callers below
3 sr.c     sr_block_ioctl      564 ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);                                            PTR_ERR propagated, caller is a block_device_operations .ioctl method


Functions calling this function: idecd_locked_ioctl

  File     Function    Line
0 ide-cd.c idecd_ioctl 1687 ret = idecd_locked_ioctl(bdev, mode, cmd, arg);                                                      PTR_ERR propagated, caller is a block_device_operations .ioctl method


Functions calling this function: scsi_ioctl

  File   Function       Line
0 ch.c   ch_ioctl        842 return scsi_ioctl(ch->device, cmd, argp);                                                           PTR_ERR propagated, see callers below
1 osst.c do_door_lock   3334 retval = scsi_ioctl(STp->device, cmd, NULL);                                                        PTR_ERR propagated, see callers below
2 osst.c osst_ioctl     5264 retval = scsi_ioctl(STp->device, cmd_in, p);                                                        PTR_ERR propagated, caller is a file_operations .compat_ioctl method
3 sd.c   sd_ioctl       1301 error = scsi_ioctl(sdp, cmd, p);                                                                    PTR_ERR propagated, caller is a file_operations .compat_ioctl method
4 sd.c   sd_ioctl       1307 error = scsi_ioctl(sdp, cmd, p);                                                                    PTR_ERR propagated, caller is a file_operations .compat_ioctl method 
5 sg.c   sg_ioctl       1096 return scsi_ioctl(sdp->device, cmd_in, p);                                                          PTR_ERR propagated, caller is a file_operations .unlocked_ioctl method
6 sg.c   sg_ioctl       1115 return scsi_ioctl(sdp->device, cmd_in, p);                                                          PTR_ERR propagated, caller is a file_operations .unlocked_ioctl method
7 sr.c   sr_block_ioctl  560 ret = scsi_ioctl(sdev, cmd, argp);                                                                  PTR_ERR propagated, caller is a block_device_operations .ioctl method
8 sr.c   sr_block_ioctl  578 ret = scsi_ioctl(sdev, cmd, argp);                                                                  PTR_ERR propagated, caller is a block_device_operations .ioctl method
9 st.c   do_door_lock    853 retval = scsi_ioctl(STp->device, cmd, NULL);                                                        PTR_ERR propagated, see callers below
a st.c   st_ioctl       3668 retval = scsi_ioctl(STp->device, cmd_in, p);                                                        PTR_ERR propagated, caller is a file_operations .compat_ioctl method


Functions calling this function: ch_ioctl

  File Function        Line
0 ch.c ch_ioctl_compat 870 return ch_ioctl(file, cmd, arg);                                                                      PTR_ERR propagated, caller is a file_operations .compat_ioctl method


Functions calling this function: do_door_lock

  File   Function            Line
0 osst.c osst_write          3447 if (STp->do_auto_lock && STp->door_locked == ST_UNLOCKED && !do_door_lock(STp, 1))             return value checked, but not propagated
1 osst.c osst_read           3740 if (STp->do_auto_lock && STp->door_locked == ST_UNLOCKED && !do_door_lock(STp, 1))             return value checked, but not propagated
2 osst.c __os_scsi_tape_open 4640 if (do_door_lock(STp, 1))                                                                      return value checked, but not propagated
3 osst.c __os_scsi_tape_open 4783 if (do_door_lock(STp, 1))                                                                      return value checked, but not propagated
4 osst.c os_scsi_tape_close  4920 do_door_lock(STp, 0);                                                                          return value ignored
5 osst.c osst_ioctl          5097 do_door_lock(STp, 0);                                                                          return value ignored
6 osst.c osst_ioctl          5149 retval = do_door_lock(STp, (mtc.mt_op == MTLOCK));                                             PTR_ERR propagated, caller is a file_operations .compat_ioctl method
7 st.c   st_release          1396 do_door_lock(STp, 0);                                                                          return value ignored
8 st.c   rw_checks           1468 !do_door_lock(STp, 1))                                                                         return value checked, but not propagated
9 st.c   st_ioctl            3466 do_door_lock(STp, 0);                                                                          return value ignored
a st.c   st_ioctl            3535 retval = do_door_lock(STp, (mtc.mt_op == MTLOCK));                                             PTR_ERR propagated, caller is a file_operations .compat_ioctl method


Functions calling this function: __blk_send_generic

  File         Function            Line
0 scsi_ioctl.c blk_send_start_stop 541 return __blk_send_generic(q, bd_disk, GPCMD_START_STOP_UNIT, data);                       PTR_ERR propagated, see callers below


Functions calling this function: blk_send_start_stop

  File         Function       Line
0 scsi_ioctl.c scsi_cmd_ioctl 661 err = blk_send_start_stop(q, bd_disk, 0x03);                                                   PTR_ERR propagated, see callers above
1 scsi_ioctl.c scsi_cmd_ioctl 664 err = blk_send_start_stop(q, bd_disk, 0x02);                                                   PTR_ERR propagated, see callers above


Functions calling this function: pd_special_command

  File Function        Line
0 pd.c pd_open         745 pd_special_command(disk, pd_media_check);                                                             return value ignored
1 pd.c pd_open         746 pd_special_command(disk, pd_door_lock);                                                               return value ignored
2 pd.c pd_ioctl        778 pd_special_command(disk, pd_eject);                                                                   return value ignored
3 pd.c pd_release      792 pd_special_command(disk, pd_door_unlock);                                                             return value ignored
4 pd.c pd_check_events 802 pd_special_command(disk, pd_media_check);                                                             return value ignored
5 pd.c pd_revalidate   811 if (pd_special_command(disk, pd_identify) == 0)                                                       return value checked, but not propagated
6 pd.c pd_probe_drive  845 if (pd_special_command(disk, pd_identify) == 0)                                                       return value checked, but not propagated
7 pd.c pd_probe_drive  847 } else if (pd_special_command(disk, pd_identify) == 0)                                                return value checked, but not propagated


Functions calling this function: pkt_generic_packet

  File      Function           Line
0 pktcdvd.c pkt_flush_cache     778 return pkt_generic_packet(pd, &cgc);
1 pktcdvd.c pkt_set_speed       799 if ((ret = pkt_generic_packet(pd, &cgc)))                                                    PTR_ERR propagated, see callers below TODO
2 pktcdvd.c pkt_mode_sense     1573 return pkt_generic_packet(pd, cgc);                                                          PTR_ERR propagated, see callers below TODO
3 pktcdvd.c pkt_mode_select    1585 return pkt_generic_packet(pd, cgc);                                                          PTR_ERR propagated, see callers below TODO
4 pktcdvd.c pkt_get_disc_info  1599 if ((ret = pkt_generic_packet(pd, &cgc)))                                                    PTR_ERR propagated, see callers below TODO
5 pktcdvd.c pkt_get_disc_info  1612 return pkt_generic_packet(pd, &cgc);                                                         PTR_ERR propagated, see callers below TODO
6 pktcdvd.c pkt_get_track_info 1628 if ((ret = pkt_generic_packet(pd, &cgc)))                                                    PTR_ERR propagated, see callers below TODO
7 pktcdvd.c pkt_get_track_info 1638 return pkt_generic_packet(pd, &cgc);                                                         PTR_ERR propagated, see callers below TODO
8 pktcdvd.c pkt_probe_settings 1850 ret = pkt_generic_packet(pd, &cgc);                                                          PTR_ERR propagated, see callers below TODO
9 pktcdvd.c pkt_lock_door      1977 return pkt_generic_packet(pd, &cgc);                                                         PTR_ERR propagated, see callers below TODO
a pktcdvd.c pkt_media_speed    2059 ret = pkt_generic_packet(pd, &cgc);                                                          PTR_ERR propagated, see callers below TODO
b pktcdvd.c pkt_media_speed    2074 ret = pkt_generic_packet(pd, &cgc);                                                          PTR_ERR propagated, see callers below TODO
c pktcdvd.c pkt_perform_opc    2130 if ((ret = pkt_generic_packet(pd, &cgc)))                                                    PTR_ERR propagated, see callers below TODO


Functions calling this function: cdrom_read_cdda_bpc

  File    Function        Line
0 cdrom.c cdrom_read_cdda 2243 ret = cdrom_read_cdda_bpc(cdi, ubuf, lba, nframes);                                               PTR_ERR propagated, see callers below


Functions calling this function: cdrom_read_cdda

  File    Function                   Line
0 cdrom.c mmc_ioctl_cdrom_read_audio 3009 return cdrom_read_cdda(cdi, ra.buf, lba, ra.nframes);                                  PTR_ERR propagated, see callers below


Functions calling this function: mmc_ioctl_cdrom_read_audio

  File    Function  Line
0 cdrom.c mmc_ioctl 3271 return mmc_ioctl_cdrom_read_audio(cdi, userptr);                                                        PTR_ERR propagated, see callers below


Functions calling this function: mmc_ioctl

  File    Function    Line
0 cdrom.c cdrom_ioctl 3362 ret = mmc_ioctl(cdi, cmd, arg);                                                                       filters out -ENOTTY, PTR_ERR propagated, see callers above


Functions calling this function: sg_start_req

  File Function        Line
0 sg.c sg_common_write 761 k = sg_start_req(srp, cmnd);                                                                          PTR_ERR propagated, see callers below


Functions calling this function: sg_common_write

  File Function     Line
0 sg.c sg_write     666 k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);                                             PTR_ERR propagated, caller is a file_operations .write method
1 sg.c sg_new_write 734 k = sg_common_write(sfp, srp, cmnd, timeout, blocking);                                                  PTR_ERR propagated, see callers below


Functions calling this function: sg_new_write

  File Function Line
0 sg.c sg_write 589 return sg_new_write(sfp, filp, buf, count,                                                                   PTR_ERR propagated, caller is a file_operations .write method
1 sg.c sg_ioctl 835 result = sg_new_write(sfp, filp, p, SZ_SG_IO_HDR,                                                            PTR_ERR propagated, caller is a file_operations .unlocked_ioctl method

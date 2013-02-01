Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3BARsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 12:48:23 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:38421 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3BARsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 12:48:20 -0500
MIME-Version: 1.0
Reply-To: syrine.tl@gmail.com
Date: Fri, 1 Feb 2013 18:48:19 +0100
Message-ID: <CAETb2JP0z7JKnuiu==PeVMugr2NS1jgAsisXEc+59w0K=4tSrw@mail.gmail.com>
Subject: Unchecked Null pointers
From: syrine tlili <syrine.tl@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:
I would like to report a set of errors found in the source tree of
Linux version 3.0.52 using a static analysis tool for vulnerability
detection that I'm developing  based on GCC.
I have performed the security analysis on the whole linux 3.0.52
distribution and my tool detected 18 errors related to the use of
unchecked potential  null pointers.
Some of these errors are also present in recent kernel versions such
as version 3.6.4
Details on the detected errors are listed below.
I'm looking forward to getting your feedback on the reported errors.

Syrine Tlili, Ph.D

File : linux-3.0.52/arch/x86/
platform/efi/efi.c,
Function :  __init efi_enter_virtual_mode
path : line 627, line 630

void __init efi_enter_virtual_mode(void)
{
    .....
    new_memmap = krealloc(new_memmap,
                      (count + 1) * memmap.desc_size,
                      GFP_KERNEL);
    memcpy(new_memmap + (count * memmap.desc_size), md,
               memmap.desc_size);
    count++;
}

-------------------------------------------------------------------------------------------------------------------------------------

File : linux-3.0.52/kernel/sched.c,
Funtion :  __init sched_init
Path : Line 8034, 8038

 void __init sched_init(void)
{

    .....
    if (alloc_size) {
        ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);

#ifdef CONFIG_FAIR_GROUP_SCHED
        root_task_group.se = (struct sched_entity **)ptr;
        ptr += nr_cpu_ids * sizeof(void **);

        root_task_group.cfs_rq = (struct cfs_rq **)ptr;
        ptr += nr_cpu_ids * sizeof(void **);


-------------------------------------------------------------------------------------------------------------------------------------

File: linux-3.0.52/mm/vmalloc.c,
Function: __init vmalloc_init
Path: line 1176, 1177

 void __init vmalloc_init(void)
{
....
    /* Import existing vmlist entries. */
    for (tmp = vmlist; tmp; tmp = tmp->next) {
        va = kzalloc(sizeof(struct vmap_area), GFP_NOWAIT);
        va->flags = VM_VM_AREA;
        va->va_start = (unsigned long)tmp->addr;
        va->va_end = va->va_start + tmp->size;
        va->vm = tmp;
        __insert_vmap_area(va);
    }
...
}


-------------------------------------------------------------------------------------------------------------------------------------


File: /linux-3.0.52/fs/ceph/mdsmap.c
Funtion:  ceph_mdsmap_decode
Path : line 133, line 136

 struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
{
    ...
    if (num_export_targets) {
        m->m_info[mds].export_targets =
            kcalloc(num_export_targets, sizeof(u32),
                        GFP_NOFS);
            for (j = 0; j < num_export_targets; j++)
                m->m_info[mds].export_targets[j] =
                           ceph_decode_32(&pexport_targets);
            } else {
                m->m_info[mds].export_targets = NULL;
            }
 }


-------------------------------------------------------------------------------------------------------------------------------------

File: /linux-3.0.52/fs/gfs2/log.c
Function: gfs2_log_flush
Path: line 733, line 752
False Positive : __GFP_NOFAIL flag is set

void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
{
...
    ai = kzalloc(sizeof(struct gfs2_ail), GFP_NOFS | __GFP_NOFAIL);
...
    ai->ai_first = sdp->sd_log_flush_head;

}


-------------------------------------------------------------------------------------------------------------------------------------


File: /linux-3.0.52/fs/gfs2/rgrp.c, 1859
Path: line 1859, 1862
Funtion: gfs2_rlist_alloc
False positive : Flag GFP_NOFAIL is set


 void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state)
{
    unsigned int x;

    rlist->rl_ghs = kcalloc(rlist->rl_rgrps, sizeof(struct gfs2_holder),
                GFP_NOFS | __GFP_NOFAIL);
    for (x = 0; x < rlist->rl_rgrps; x++)
        gfs2_holder_init(rlist->rl_rgd[x]->rd_gl,
                state, 0,
                &rlist->rl_ghs[x]);
}



-------------------------------------------------------------------------------------------------------------------------------------


File: /linux-3.6.4/fs/gfs2/rgrp.c, 2283
Function: gfs2_rlist_add
Path: Line 2283, 2293, 2296
False positive : Flag __GFP_NOFAIL is set

 tmp = kcalloc(new_space, sizeof(struct gfs2_rgrpd *),
                  GFP_NOFS | __GFP_NOFAIL);

        if (rlist->rl_rgd) {
            memcpy(tmp, rlist->rl_rgd,
                   rlist->rl_space * sizeof(struct gfs2_rgrpd *));
            kfree(rlist->rl_rgd);
        }

        rlist->rl_space = new_space;
        rlist->rl_rgd = tmp;
    }

    rlist->rl_rgd[rlist->rl_rgrps++] = rgd;
}



-------------------------------------------------------------------------------------------------------------------------------------

File: linux-3.0.52/fs/gfs2/rgrp.c
Function: rgblk_free
Path: line 1440, 1441
False positive

static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
                     u32 blen, unsigned char new_state)
{
...
        if (!bi->bi_clone) {
            bi->bi_clone = kmalloc(bi->bi_bh->b_size,
                           GFP_NOFS | __GFP_NOFAIL);
            memcpy(bi->bi_clone + bi->bi_offset,
                   bi->bi_bh->b_data + bi->bi_offset,
                   bi->bi_len);
        }



-------------------------------------------------------------------------------------------------------------------------------------

File: /linux-3.0.52/drivers/gpu/drm/radeon/atom.c
Function: atom_parse
Line:  Line 1251, line 1257

 struct atom_context *atom_parse(struct card_info *card, void *bios)
{
    int base;
    struct atom_context *ctx =
        kzalloc(sizeof(struct atom_context), GFP_KERNEL);
    char *str;
    char name[512];
    int i;

    ctx->card = card;
    ctx->bios = bios;
    ...
    }


-------------------------------------------------------------------------------------------------------------------------------------

File: /linux-3.0.52/drivers/gpu/drm/drm_fb_helper.c,
Function: drm_setup_crtcs
Path: Line 1300, Line 1302, Line 1304

 static void drm_setup_crtcs(struct drm_fb_helper *fb_helper)
{
....
    crtcs = kcalloc(dev->mode_config.num_connector,
            sizeof(struct drm_fb_helper_crtc *), GFP_KERNEL);
    modes = kcalloc(dev->mode_config.num_connector,
            sizeof(struct drm_display_mode *), GFP_KERNEL);
    enabled = kcalloc(dev->mode_config.num_connector,
              sizeof(bool), GFP_KERNEL);

    drm_enable_connectors(fb_helper, enabled);  //unchecked ptr enabled

    ret = drm_target_cloned(fb_helper, modes, enabled, width, height);
    if (!ret) {
        ret = drm_target_preferred(fb_helper, modes, enabled, width, height);
        if (!ret)
            DRM_ERROR("Unable to find initial modes\n");
    }

.....
    for (i = 0; i < fb_helper->connector_count; i++) {
        struct drm_display_mode *mode = modes[i];     //unchecked ptr modes
        struct drm_fb_helper_crtc *fb_crtc = crtcs[i]; //unchecked ptr crtcs
        modeset = &fb_crtc->mode_set;
}



-------------------------------------------------------------------------------------------------------------------------------------

File: /linux-3.0.52/drivers/isdn/mISDN/fsm.c, 35
Path: Line 35, Line 46
Function: mISDN_FsmNew

void
mISDN_FsmNew(struct Fsm *fsm,
       struct FsmNode *fnlist, int fncount)
{
    int i;

    fsm->jumpmatrix = kzalloc(sizeof(FSMFNPTR) * fsm->state_count *
        fsm->event_count, GFP_KERNEL);

    for (i = 0; i < fncount; i++)
        if ((fnlist[i].state >= fsm->state_count) ||
            (fnlist[i].event >= fsm->event_count)) {
            printk(KERN_ERR
                "mISDN_FsmNew Error: %d st(%ld/%ld) ev(%ld/%ld)\n",
                i, (long)fnlist[i].state, (long)fsm->state_count,
                (long)fnlist[i].event, (long)fsm->event_count);
        } else
            fsm->jumpmatrix[fsm->state_count * fnlist[i].event +
                fnlist[i].state] = (FSMFNPTR) fnlist[i].routine;
}


-------------------------------------------------------------------------------------------------------------------------------------

File: /linux-3.0.52/drivers/media/video/cx231xx/cx231xx-417.c
Function:  cx231xx_bulk_copy
Path: Line 1369, Line 1371

static inline int cx231xx_bulk_copy(struct cx231xx *dev, struct urb *urb)
{

    ...
    buffer = kmalloc(buffer_size, GFP_ATOMIC);

    memcpy(buffer, dma_q->ps_head, 3);
    memcpy(buffer+3, p_buffer, buffer_size-3);
    memcpy(dma_q->ps_head, p_buffer+buffer_size-3, 3);

    p_buffer = buffer;
    buffer_filled(p_buffer, buffer_size, urb, dma_q);

    kfree(buffer);
    return 0;
}



-------------------------------------------------------------------------------------------------------------------------------------

File: /linux-3.0.52/drivers/scsi/be2iscsi/be_main.c,
Path: Line 2407, 2410, 2416, 2417, 2435
Function:  beiscsi_init_wrb_handle

 static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
{
         pwrb_context->pwrb_handle_base =
                 kzalloc(sizeof(struct wrb_handle *) *
                    phba->params.wrbs_per_cxn, GFP_KERNEL);
        pwrb_context->pwrb_handle_basestd =
                kzalloc(sizeof(struct wrb_handle *) *
                    phba->params.wrbs_per_cxn, GFP_KERNEL);
        if (num_cxn_wrbh) {
            pwrb_context->alloc_index = 0;
            pwrb_context->wrb_handles_available = 0;
            for (j = 0; j < phba->params.wrbs_per_cxn; j++) {
                pwrb_context->pwrb_handle_base[j] = pwrb_handle;  //line 2416
                pwrb_context->pwrb_handle_basestd[j] =           //line 2417
                                pwrb_handle;
 .....
 for (j = 0; j < phba->params.wrbs_per_cxn; j++) {
                pwrb_context->pwrb_handle_base[j] = pwrb_handle;  //line 2435
                pwrb_context->pwrb_handle_basestd[j] =          //line 2436
                    pwrb_handle;


-------------------------------------------------------------------------------------------------------------------------------------


File: /linux-3.0.52/drivers/scsi/megaraid.c
Path: Line 4437, Line 4438, Line 4442
Function: mega_internal_command


     sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
    scmd->device = sdev; //ptr aliasing

    memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
    scmd->cmnd = adapter->int_cdb;
    scmd->device->host = adapter->host;



-------------------------------------------------------------------------------------------------------------------------------------


File: /linux-3.0.52/drivers/tty/vt/vt.c,
Path: Line 2918, line 2922
Function: __init con_init

 static int __init con_init(void)
 .....
 vc_cons[currcons].d = vc = kzalloc(sizeof(struct vc_data), GFP_NOWAIT);
        INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
        tty_port_init(&vc->port);
        visual_init(vc, currcons, 1);
        vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);



-------------------------------------------------------------------------------------------------------------------------------------

File: /linux-3.0.52/drivers/xen/events.c
Path: Line 1676, Line 1679
Function: xen_init_IRQ

 void __init xen_init_IRQ(void)
{
    int i;

    evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
                    GFP_KERNEL);
    for (i = 0; i < NR_EVENT_CHANNELS; i++)
        evtchn_to_irq[i] = -1;



-------------------------------------------------------------------------------------------------------------------------------------


File: /linux-3.0.52/sound/pci/als300.c,
Path: Line 418, Line 425
Function: snd_als300_capture_open

static int snd_als300_capture_open(struct snd_pcm_substream *substream)
{
...
    struct snd_als300_substream_data *data = kzalloc(sizeof(*data),
                                GFP_KERNEL);

    snd_als300_dbgcallenter();
    chip->capture_substream = substream;
    runtime->hw = snd_als300_capture_hw;
    runtime->private_data = data;
    data->control_register = RECORD_CONTROL;
    data->block_counter_register = RECORD_BLOCK_COUNTER;



-------------------------------------------------------------------------------------------------------------------------------------


File: /linux-3.0.52/sound/pci/als300.c
Path: Line 387, Line 394
Function: snd_als300_playback_open

struct snd_als300_substream_data *data = kzalloc(sizeof(*data),
                                GFP_KERNEL);

    snd_als300_dbgcallenter();
    chip->playback_substream = substream;
    runtime->hw = snd_als300_playback_hw;
    runtime->private_data = data;
    data->control_register = PLAYBACK_CONTROL;
